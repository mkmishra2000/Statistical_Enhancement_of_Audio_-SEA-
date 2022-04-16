%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author :- Niranjana Vannadil
% Function for Noise Estimation using Minimum Statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [1] Martin, R. 
%     "Noise power spectral density estimation based on optimal smoothing
%      and minimum statistics" 
%      IEEE Transactions on Speech and Audio Processing, 2001, 9, 504-512


%INPUTS
%
%

%OUTPUTS
%
%

function[N_PSD, Smoothed_Perio, alpha, lambda_d] = Noise_Estimation_Minimum_Statistics(Periodogram)
    %Setting default values
    alpha_max = 0.96;  %as per reference
    alpha_min = 0.3;
    Y_Energy_min = 1e-9;
    
    %Initializations
    
    % alpha = 0 when only speech present. alpha = 1 when only noise present.
    %Assuming that there is only noise initialy.

    alpha_c_prev = 1; %Initial value of alpha(lambda-1)
    tshift = 16e-3;  %initialize to window shift
    tdecay = 64e-3;  
    snr_exp = -tshift/tdecay;
    [len1, n_frames1] = size(Periodogram);
    N_PSD = zeros(len1,n_frames1);
    lambda_d = zeros(n_frames1);
    Smoothed_Perio = zeros(len1,n_frames1);
    alpha = zeros(len1,n_frames1);
    
    %Initializations for the search
    D=160;  %value ?
    V=16;  %value?
    M_D = mean_of_the_min_table3(D);
    M_V = mean_of_the_min_table3(V);
    a_v = 2.12;  %as per ref[1]
    MAX_VALUE = 1e9;  %value?
    U = round(D/V);
    buff_idx = 1;
    subwc = V;
    actmin_buff = MAX_VALUE*ones(len1,U);
    actmin = MAX_VALUE*ones(len1,1);
    actmin_sub = MAX_VALUE*ones(len1,1);
    lmin_flag = zeros(len1,1);

    noise_slope_max_table = [0.03 8; 
                             0.05 4; 
                             0.06 2];   % as per figure 5 in ref[1]
    
   
    
    Perio = Periodogram  ;  %Periodogram
    
    
    Smoothed_Perio_prev = Perio(:,1);
    N_PSD(:,1) = Perio(:,1);
    N_PSD_prev = Perio(:,1);
    lambd_d(1) = mean(N_PSD_prev.^2)
    Mean_Smoothed_Perio = Perio(:,1);
    Mean_Smoothed_Perio_2 = Mean_Smoothed_Perio.^2 ;
    
    
    for lambda = 1:n_frames1
        Y_Energy = sum(Perio(:,lambda));
        Smoothed_Perio_energy = sum(Smoothed_Perio_prev);
        if (Y_Energy ==0)
            Y_Energy = Y_Energy_min;
        end
    
        %Step 2: Computing alpha
    
        alpha_c = 1/(1+(Smoothed_Perio_energy./Y_Energy-1)^2);  % Equation 9 ref[1]
        alpha_c = (0.7*alpha_c_prev) + (0.3*max(alpha_c,0.7)); % Equation 10 ref[1]
        alpha_c_prev = alpha_c; %updating alpha_c previous frame value for next iteration
        alpha_opt = (alpha_max*alpha_c)./(1+(Smoothed_Perio_prev./N_PSD_prev-1).^2); % Equation 11 ref[1]
        snr = (Smoothed_Perio_energy/ sum(N_PSD_prev));
        alpha_min = min (0.3,snr^(snr_exp)); %to avoid attenuation of weak consonants
        alpha_opt = max(alpha_opt,alpha_min);  %to use alpha_min from eq 12 ref[1]
        alpha(:,lambda) = alpha_opt; % Setting alpha for the entire frame as alpha_opt
    
    
        %Step 3 : Computing smoothed power
        
        Smoothed_Perio(:,lambda) = (alpha_opt .* Smoothed_Perio_prev) + ((1-alpha_opt).*Perio(:,lambda));
    
        %Step 4 : Computing Bias Correction Factor
        Beta = min(alpha_opt.^2, 0.8); % Based on [1] good results are obtained by limiting beta to <=0.8
        Mean_Smoothed_Perio = (Beta.*Mean_Smoothed_Perio) + (1-Beta).*(Smoothed_Perio(:,lambda));  % Equation 20 [1]
        Mean_Smoothed_Perio_2 = (Beta.*Mean_Smoothed_Perio_2) + (1-Beta).*(Smoothed_Perio(:,lambda).^2);  % Equation 21 [1]
        P_variance = Mean_Smoothed_Perio_2 - (Mean_Smoothed_Perio.^2); % Equation 22
    
        Qeq_inverse = P_variance./(2*N_PSD_prev.^2);  % Equation 23
        
        Qeq_tilda_inverse_D = ((1./Qeq_inverse)-2*(M_D))/(1-M_D);
        Qeq_tilda_inverse_V = ((1./Qeq_inverse)-2*(M_V))/(1-M_V);
    
        B_min = 1+((D-1)*2)./Qeq_tilda_inverse_D; % Equation 17 ref[1] used (15 can also be used)
        B_min_sub = 1 + 2*(V-1)./Qeq_tilda_inverse_V;
        Qeq_inverse = mean(Qeq_inverse);
        B_c = 1+a_v*sqrt(Qeq_inverse);
    
    
          % Step 5: Search for minimum PSD :
    
          P_x_B_min_x_B_c = Smoothed_Perio(:,lambda).*B_min.*B_c; % applying the bias corrections
          k_mode = P_x_B_min_x_B_c < actmin;
          actmin(k_mode) = P_x_B_min_x_B_c(k_mode);
          actmin_sub(k_mode) = Smoothed_Perio(k_mode,lambda).*B_min_sub(k_mode)*B_c; % bias correction in the sub-window
          if subwc == V
            lmin_flag(k_mode) = 0;
            actmin_buff(:,buff_idx) = actmin;
            if buff_idx == U
              buff_idx = 1;  %Setting index back to one after each subwindow
            else
              buff_idx = buff_idx + 1;  %incrementing the index
            end
            P_min_u = min(actmin_buff,[],2);
            p = find(Qeq_inverse < noise_slope_max_table(:,1));
            if isempty(p)
              noise_slope_max = 1.2;
            else
              noise_slope_max = noise_slope_max_table(p(1),2);
            end
            p = and(and(lmin_flag, actmin_sub < noise_slope_max.*P_min_u),...
                    actmin_sub > P_min_u);
            if any(p)
              P_min_u(p) = actmin_sub(p);
              actmin(p) = actmin_sub(p);
            end
            lmin_flag = zeros(len1,1);
            subwc = 1;
            actmin(:) = MAX_VALUE;
            actmin_sub(:) = MAX_VALUE;
            N_PSD(:,lambda) = P_min_u;
          else
            if subwc > 1
              lmin_flag(k_mode) = 1;
              N_PSD(:,lambda) = min(actmin_sub,P_min_u);
              P_min_u = N_PSD(:,lambda);
            else
              N_PSD(:,lambda) = min(actmin_sub,P_min_u);
            end
            subwc = subwc + 1;
          end
          Smoothed_Perio_prev = Smoothed_Perio(:,lambda); 

          %Step 6: Updating Noise PSD
          N_PSD_prev = N_PSD(:,lambda);
          lambda_d(lambda) = sum(abs(N_PSD(:,lambda)));
    end
end


function [M_D, H_D] = mean_of_the_min_table3(D)
DMH = [  1 0.000 0.000;   2 0.260 0.150;   5 0.480 0.480;   8 0.580 0.780; ...
        10 0.610 0.980;  15 0.668 1.550;  20 0.705 2.000;  30 0.762 2.300; ...
        40 0.800 2.520;  60 0.841 2.900;  80 0.865 3.250; 120 0.890 4.000; ...
       140 0.900 4.100; 160 0.910 4.100];

 p = find(DMH(:,1) == D);
 if ~isempty(p)
   M_D = DMH(p,2);
   H_D = DMH(p,3);
 else 
   p = find(DMH(:,1) < D);
   if isempty(p)
     error('invalid value for: D');
   end
   p = p(end);
   if p > size(DMH,1)-1
     error('invalid value for: D');
   end
   delta_p_rat = (D - DMH(p,1))/(DMH(p+1,1)-DMH(p,1));
   M_D = DMH(p,2) + (DMH(p+1,2)-DMH(p,2))*delta_p_rat;
   H_D = DMH(p,3) + (DMH(p+1,3)-DMH(p,3))*delta_p_rat;
 end
end