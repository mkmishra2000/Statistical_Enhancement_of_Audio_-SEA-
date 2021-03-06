%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author :- Manas Kumar Mishra
% Function for getting frame matrices from the Audio samples 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inputs are
% 1. Audio :- Two channel audio
% 2. Winlen:- Window length (integer)
% 3. OverlapLen :- Overlap length
% 4. WindowType:- Type pf window

% Outputs are
% Frame1 :- Frame matrix one contain the frame of audio sample 1
% Frame2 :- Frame matrix two contain the frame of audio sample 2


function[Frames1, Frames2] = Framing(Audio, WinLen, OverlapLen, WindowType)

    Samples1 = Audio(:,1)';
    Samples2 = Audio(:,2)';
    
    % Hamming window
    if(WindowType == 1)
        Window = hamming(WinLen);
    else
        Window = hamming(WinLen);
    end
    
    % Convert into raw to column
    Window = Window(:);
    
    % Shift percentage 
    ShiftPer = 1 - OverlapLen;
    
    Sp = fix(WinLen*ShiftPer);
    
    Len = length(Samples1);
    
    % Number of segments
    N=fix((Len-WinLen)/Sp +1);
    
    % Index Matrix
    Index =(repmat(1:WinLen,N,1)+repmat((0:(N-1))'*Sp,1,WinLen))';
    
    hwin = repmat(Window,1,N);
    
    Frames1 = Samples1(Index).*hwin;
    Frames2 = Samples2(Index).*hwin;
    
end
