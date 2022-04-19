function MOS=pesq(CleanSignal,DegradedSignal,rate)
% 1. Put clean and degraded wav files 
% 2. build pesq from ITU source code (available on the ITU p.862) and
%    generate pesq.exe
% 3. Put the pesq.exe in the current path
% 4. Use it like this exp. :
%    MOS=pesq('CleanSignal.wav','DegradedSignal.wav','+8000')
%    rate :  Must select either +8000 or +16000.
% 5. Enjoy it
%
%   By. Meysam Shakiba. Meysam.shakiba@gmail.com

[Return,strout]=system(['PESQ ',rate,' ',CleanSignal,' ',DegradedSignal])

c=strfind(strout,'(Raw MOS, MOS-LQO):');


if isempty(c)
    disp('Error!!!!!!!!');
    MOS='It is not valid';
else
    MOS_Raw=str2double(strout(c+23:c+28));
    MOS_LQO=str2double(strout(c+29:end-1));
    disp('    MOS_Raw   MOS_LQO');
    disp([MOS_Raw,MOS_LQO]);
    MOS(1)=MOS_Raw;
    MOS(2)=MOS_LQO;
end
