%Vishnu... thank you for electronics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name :- MANAS KUMAR MISHRA
% Audio analysis in the matlab
% Task :- Show the periodogram of the signal with chossen window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function ShowPSD(Audio, fsample)
    
    % Divide the both channel sounds

    firstChannel = Audio(:,1);
    secondChannel = Audio(:,2);

    % Length of the channel
    Nfirst = length(firstChannel);
    Nsecond = length(secondChannel);
    
    
    % Power spectral density for first channel
    WindowLength1 = Nfirst;
    WindowLength2 = Nsecond;
    
    quest = 'Enter the window type for power spectral analysis';
    dgltitle= 'Window selection';
    btn1 ='Hanning';
    btn2 ='Hamming';
    btn3 = 'Blackman';

    defbtn = btn1;

    answer = questdlg(quest, dgltitle, btn1, btn2, btn3, defbtn);

    switch answer
        case btn1
            win = hann(WindowLength1, 'periodic'); %periodic flag is for spectral analysis.
        case btn2
            win = hamming(WindowLength1, 'periodic');
        case btn3
            win = blackman(WindowLength1, 'periodic');
    end



    nfft1 = round(2*WindowLength1);
    nfft2 = round(2*WindowLength2);
    [PS1, freq1] = periodogram(firstChannel, win, nfft1, fsample, 'power');
    [PS2, freq2] = periodogram(secondChannel, win, nfft2, fsample, 'power');
    X1 = 10*log10(PS1);
    X2 = 10*log10(PS2);
    w_normal1 = (2.*freq1)/fsample;
    w_normal2 = (2.*freq2)/fsample;

    figure;
    subplot(2,2,1);
    plot(w_normal1,X1);
    grid on;
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
    xlabel("Normalized frequency");
    ylabel("power");
    title("Power Spectral Density of first channel");

    subplot(2,2,3);
    semilogx(freq1, X1,'r', 'LineWidth',1);
    grid on;
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
    xlabel("frequency");
    ylabel("power");
    title("Power Spectral Density in log scale of first channel");

    subplot(2,2,2);
    plot(w_normal2,X2);
    grid on;
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
    xlabel("Normalized frequency");
    ylabel("power");
    title("Power Spectral Density of second channel");

    subplot(2,2,4);
    semilogx(freq2, X2,'r', 'LineWidth',1);
    grid on;
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);
    xlabel("frequency");
    ylabel("power");
    title("Power Spectral Density in log scale of second channel");
    
end