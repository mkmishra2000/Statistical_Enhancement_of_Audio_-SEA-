% TEST_PESQ2_MTLB demonstrates use of the PESQ2_MTLB function
%
%   See also PESQ2_MTLB
%
%   Author: Arkadiy Prodeus, email: aprodeus@gmail.com, July 2014

clear all; close all; clc;

    % name of executable file for PESQ calculation
    binary = 'pesq2.exe';

    % specify path to folder with reference and degraded audio files in it
    pathaudio = 'sounds';

    % specify reference and degraded audio files
    reference = 'speech.wav';
    degraded = 'speech_bab_0dB.wav';
    reference2 = 'or105.08k.raw';
    degraded2 = 'dg105.08k.raw';
    
    % compute NB-PESQ and WB-PESQ scores for wav-files
    nb = pesq2_mtlb( reference, degraded, 16000, 'nb', binary, pathaudio );
    wb = pesq2_mtlb( reference, degraded, 16000, 'wb', binary, pathaudio );
    
    % compute NB-PESQ score for raw-files
    nb2 = pesq2_mtlb( reference2, degraded2, 8000, 'nb', binary, pathaudio );
    
    % display results to screen
    fprintf('====================\n'); 
    disp('Example 1: compute NB-PESQ scores for wav-files:');
    fprintf( 'NB PESQ MOS = %5.3f\n', nb(1) );
    fprintf( 'NB MOS LQO  = %5.3f\n', nb(2) );
    
    % example 1 output
    %    NB PESQ MOS = 1.969
    %    NB MOS LQO  = 1.607
    
    fprintf('====================\n'); 
    disp('Example 2: compute WB-PESQ score for wav-files:');
    fprintf( 'WB MOS LQO  = %5.3f\n', wb );

    % example 2 output
    %    WB MOS LQO  = 1.083

    fprintf('====================\n'); 
    disp('Example 3: compute NB-PESQ scores for raw-files:');
    fprintf( 'NB PESQ MOS = %5.3f\n', nb2(1) );
    fprintf( 'NB MOS LQO  = %5.3f\n', nb2(2) );

    % example 3 output
    %    NB PESQ MOS = 2.237
    %    NB MOS LQO  = 1.844

    fprintf('==================================\n'); 

% EOF
