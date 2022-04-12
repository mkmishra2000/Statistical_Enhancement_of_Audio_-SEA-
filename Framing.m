
function[Frames1, Frames2] = Framing(Audio, WinLen, OverlapLen, WindowType)

    Samples1 = Audio(:,1)';
    Samples2 = Audio(:,2)';
    
    if(WindowType == 1)
        Window = hamming(WinLen);
    else
        Window = hamming(WinLen);
    end
    
    Window = Window(:);
    
    % Shift percentage 
    ShiftPer = 1 - OverlapLen;
    
    Sp = fix(WinLen*ShiftPer);
    
    Len = length(Samples1);
    
    N=fix((Len-WinLen)/Sp +1);
    
    Index =(repmat(1:WinLen,N,1)+repmat((0:(N-1))'*Sp,1,WinLen))';
    
    hwin = repmat(Window,1,N);
    
    Frames1 = Samples1(Index).*hwin;
    Frames2 = Samples2(Index).*hwin;
    
end
