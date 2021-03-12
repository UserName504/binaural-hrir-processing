%**************************************************************************
% Y3854349
% University of York
% Department of Electronic Engineering
% MSc Audio and Music Technology
% ELE00087M: Audio Signals and Psychoacoustics
%**************************************************************************
% Implementation of convolution through the overlap-add method, with a
% fixed impulse response.
%**************************************************************************
%
load HRIRs_0el_IRC_subject59

[fire, wav_Fs] = audioread('Fire.wav'); % Load audio file.
if wav_Fs ~= Fs; 
    error('Sampling frequencies must be the same'); 
end
fireR    = fire(:, 1);       % (If necessary) this reduces a stereo input to mono
fireL    = fire(:, 1);
Ninput   = length(fire);     % The number of samples in the input signal
y_length = Ninput + 512 - 1; % The number of samples created by convolving x and IR
Noutput  = y_length;         % and therefore the number of output samples

frame_size     = 1024;                          % The number of samples in a frame
frame_conv_len = 1024 + 512 - 1;                % The number of samples created by convolving a frame of x and IR
step_size      = 512;                           % Step size for 50% overlap-add
w              = hann(frame_size, 'periodic');  % Generate the Hann function to window a frame
Nframes        = floor(Ninput / step_size) - 1; % -1 prevents input overrun in the final frame
y              = zeros (y_length, 2);           % Initialise the output vector y to zero
yR             = zeros (y_length, 1);           % Initialise the output vector y to zero
yL             = zeros (y_length, 1);           % Initialise the output vector y to zero

Direction180L = HRIR_set_L(13, : );
Direction180R = HRIR_set_R(13, : );

display('Computing convolution by conv overlap-and-add')
tic
% Convolve each frame of the input vector with the impulse response
frame_start = 1;
for n = 1 : Nframes
    % Apply the window to the current frame of the input vector x
    fireFrameR = w.*fireR(frame_start:frame_start + frame_size - 1);
    fireFrameL = w.*fireL(frame_start:frame_start + frame_size - 1);
    % Convolve the impulse response with this frame
    fireConvResultR = conv(fireFrameR,Direction180R);
    fireConvResultL = conv(fireFrameL,Direction180L);
    % Add the convolution result for this frame into the output vector y
    yR(frame_start:frame_start + frame_conv_len - 1) = yR(frame_start:frame_start + frame_conv_len - 1) + fireConvResultR;
    yL(frame_start:frame_start + frame_conv_len - 1) = yL(frame_start:frame_start + frame_conv_len - 1) + fireConvResultL;
    % Advance to the start of the next frame
    frame_start = step_size + frame_start;
end
display(['Computation took ' num2str(toc) ' seconds'])
y(:, 1) = yL;
y(:, 2) = yR;

% Save spatialised sound as a new audio file.
audiowrite('Fire_Spatialised.wav',fire, wav_Fs); 