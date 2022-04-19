 ======  PESQ2_MTLB as MATLAB driver for the PESQ binary version 2.0. =====

   PESQ2_MTLB is MATLAB driver for speech quality calculation
 in accordance with PESQ version 2.0 [1] on Windows operating system. 
   PESQ2_MTLB uses executable file PESQ2.EXE, which should be placed 
 at the same directory where PESQ2_MTLB is present.
   PESQ2.EXE can be compiled from C sources, which are freely available 
 for downloading from ITU-T website [1].

   ATTENTION: you have pesq.exe after compiling, but you need rename it to pesq2.exe

   PESQ2_MTLB uses STDOUT2SCORES function developed by Kamil Wojcicki [2].
   
   PESQ version 2.0 supports both NB-PESQ (narrowband PESQ measure) 
   as well as WB-PESQ (wideband PESQ measure).
   This driver supports both modes through the MODE parameter.

   SYNTAX:
            [ SCORES ]=PESQ2_MTLB( REF, DEG, FS, MODE, BNR, PATH )

   INPUTS:
       REF is  file name of reference signal (wav or raw)
           (file extension must be explicitly stated)

       DEG is file name of degraded signal (wav or raw)
           (file extension must be explicitly stated)

       FS is the sampling frequency in Hz for REF and DEG
           (FS values may be only 8000 or 16000)

       MODE specifies narrowband: 'nb' or wideband: 'wb'

       BNR is name (string variable) of binary file PESQ2.EXE

       PATH is path to folder which contains reference and degraded audio
       files. Full path to the folder may be pointed here if it is necessary.

   OUTPUTS: 
       SCORES is a two element array: [ PESQ_MOS, MOS_LQO ] 
       for narrowband mode, or a scalar for the 
       wideband mode: MOS_LQO

       PESQ_RESULTS.TXT is text file which contains results history
       and is saved and renewed at the same foler, were PESQ2.EXE is placed

   EXAMPLES of computing NB-PESQ and WB-PESQ scores for wav-files 
       and raw-files see at TEST_PESQ2_MTLB m-file:

    binary = 'pesq2.exe';
    pathaudio = 'sounds';
    reference = 'speech.wav';
    degraded = 'speech_bab_0dB.wav';
    reference2 = 'or105.08k.raw';
    degraded2 = 'dg105.08k.raw';
    
    % compute NB-PESQ and WB-PESQ scores for wav-files
    nb = pesq2_mtlb( reference, degraded, 16000, 'nb', binary, pathaudio );
    wb = pesq2_mtlb( reference, degraded, 16000, 'wb', binary, pathaudio );
    
    % compute NB-PESQ score for raw-files
    nb2 = pesq2_mtlb( reference2, degraded2, 8000, 'nb', binary, pathaudio );

 [1] ITU-T (2005), "P.862: Revised Annex A - Reference implementations 
     and conformance testing for ITU-T Recs P.862, P.862.1 and P.862.2"
     URL: http://www.itu.int/rec/T-REC-P.862-200511-I!Amd2/en
 [2] Wojcicki K. PESQ MATLAB Wrapper.
     URL: http://www.mathworks.com/matlabcentral/fileexchange/33820-pesq-matlab-wrapper

   Author: Arkadiy Prodeus, Jule 2014
       email: aprodeus@gmail.com