%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author :- Manas Kumar Mishra
% Function for getting filter coefficients of FIR filter 
% Windowing method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inputs are the cutoff of LPF, filter length, and window type
% If type =1 --> Rectangular window
%    type =2 --> Hamming window
%    type =3 --> Hanning window

% Output is the lpf filter coefficients

function lpfCoff = impulseResponseOfFilterLPF(Cutoff, filterLength, type)
    
    n = -floor(filterLength/2):floor(filterLength/2)-1;
    
    M = 0:filterLength-1;
    
    % Rectangular window
    RectWindow1 = ones(1, length(n));
    
    % Hamming window
    HammWindow1 = 0.54 - 0.46*cos((2*pi*M)/length(M));

    % Hanning window
    HannWindow1 = 0.5 - 0.5*cos((2*pi*M)/length(M));

    
    hfilter = zeros(1, filterLength);
    
    for i= 1:length(n)
        if(n(i) == 0)
            hfilter(i) = Cutoff;
        else
            hfilter(i) = sin((pi*Cutoff)*n(i))/(pi*n(i));
        end
    end
    
    if(type == 1)
        lpfCoff = hfilter.*RectWindow1;
    elseif(type == 2)
        lpfCoff = hfilter.*HammWindow1;
    else
        lpfCoff = hfilter.*HannWindow1;
    end
           
    
    freqz(lpfCoff);
    title("LPF design");
    
    
end