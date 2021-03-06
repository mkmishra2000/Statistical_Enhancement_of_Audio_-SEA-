
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors      :-  Manas Kumar Mishra, Niranjana Vannadil 
% Project name :-  SEA (Statistical Enhancement of Audio)
% Organization :-  IIITDM Kancheepuram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Noisy clips
% 1. TempleNoisyclip1_Agra.mp3
% 2. TempleNoisyclip2_Agra.mp3
% 3. TempleNoisyclip1_Agra.wav
% 4. TempleNoisyclip2_Agra.wav
% 5. TestAudio4.wav
% 6. TestAudio5.wav
% 7. TestAudioRaga.wav
tic

close all
clear all

[samples, fsample] = audioread('TestSongs/TempleNoisyclip2_Agra.wav');

% If PSD of audio is required to check
% ShowPSD(samples, fsample);

% Preprocessing step
Cutoff = 0.182;         %low pass cutoff

filterLength =500;      %Constant filter length 

% LPF filter cofficient
filterCoff = impulseResponseOfFilterLPF(Cutoff, filterLength, 3);

% Applying filter on the audio samples
fprintf("Wait... audio is passing through LPF \n");
NewSamples1 = myFIRFilter(samples(:, 1)', filterCoff);
NewSamples2 = myFIRFilter(samples(:, 2)', filterCoff);
fprintf("LPF operation completed \n ");

NewSample = [NewSamples1', NewSamples2'];

% Framing of the sample values
conSampleLength = 0.032;                %32 ms frame length

WinLen = ceil(conSampleLength*fsample); %number of samples per frame

overlappPerc = 0.75;                    %Overlapping percentage

[frame1, frame2]= Framing(NewSample,WinLen, overlappPerc, 1);
% [FrameSize, NumOfFrame]=size(frame1)

% Improvement of the STSA algorithm (With all improvement)
Out_Audio1 = SEA_MMSE_Imp3(frame1, fsample); 
Out_Audio2 = SEA_MMSE_Imp3(frame2, fsample);

EnhanceAudio = [Out_Audio1, Out_Audio2];

audiowrite('EnhanceAudio\Enhance1_templeNoise2.wav', EnhanceAudio, fsample);
fprintf("\n Completed \n")
toc
