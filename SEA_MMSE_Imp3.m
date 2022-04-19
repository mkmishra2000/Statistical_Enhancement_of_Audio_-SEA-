%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author:- Manas Kumar Mishra, Niranjana Vannadil
% Topic :- MMSE (STSA) algorithm (Improved version of the STSA)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input 
%     1. Audio sample is matrix that contain the audio frames
%     2. Fsample is sampleing frequency

% Output
%     1. Output 
function output = SEA_MMSE_Imp3(Audiosample, fsample)

    Y=fft(Audiosample);
    
    YPhase=angle(Y(1:fix(end),:)); %Noisy Speech Phase
    
    Y=abs(Y(1:fix(end),:));%Specrogram

    numberOfFrames=size(Y,2);
    
    FrameSize=size(Y,1);
    
    IS = 0.25;
    SP = 0.25; % Shift percentage
    
    W = ceil(0.032*fsample); % window
    
    NIS=fix((IS*fsample-W)/(SP*W) +1);%number of initial silence segments

    N=mean(Y(:,1:NIS)')'; %initial Noise Power Spectrum mean

    LambdaD =mean((Y(:,1:NIS)').^2)'; % Lambda_d 

    alpha=0.98; %0.98

    NoiseCounter=0;
    NoiseLength=9; % This is a smoothing factor for the noise updating

    G=ones(size(N));%Initial Gain used in calculation of the new xi

    Gamma=G;    

    Gamma1p5=gamma(1.5); %Gamma function at 1.5
    X=zeros(size(Y)); % Initialize X (memory allocation)

    h=waitbar(0,'Wait...');

    for i =1:numberOfFrames
        % Something
        if i<=NIS % If initial silence ignore VAD
            SpeechFlag=0;
            NoiseCounter=100;
        else % Else Do VAD
            [NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad(Y(:,i),N,NoiseCounter); %Magnitude Spectrum Distance VAD
        end

        if SpeechFlag==0 % If not Speech Update Noise Parameters
            N=(NoiseLength*N+Y(:,i))/(NoiseLength+1); %Update and smooth noise mean
            LambdaD=(NoiseLength*LambdaD+(Y(:,i).^2))./(1+NoiseLength); %Update and smooth noise variance
        end

         gammaNew=(Y(:,i).^2)./LambdaD; %A postiriori SNR

         xi=max(alpha*(G.^2).*Gamma.*(4/pi)+(1-alpha).*max(gammaNew-1,0), 0.03162); %Decision Directed Method for A Priori SNR

         Gamma=gammaNew;

         nu=Gamma.*xi./(1+xi); % A Function used in Calculation of Gain

         G=(Gamma1p5*sqrt(nu)./Gamma).*exp(-nu/2)...
            .*((1+nu).*besseli(0,nu/2) +nu.*besseli(1,nu/2)); %MMSE Gain

         Indx=find(isnan(G) | isinf(G));
         G(Indx)=xi(Indx)./(1+xi(Indx));

         X(:,i)=G.*Y(:,i); %Obtain the new Cleaned value

         waitbar(i/numberOfFrames,h,num2str(fix(100*i/numberOfFrames)));

    end

    close(h);

    output=OverlapAdd2(X,YPhase,W,SP*W);
end