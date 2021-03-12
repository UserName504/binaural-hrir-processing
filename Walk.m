% LOAD HRIR dataset here:
load HRIRs_0el_IRC_subject59

% LOAD audio input here:
[walk, wav_Fs] = audioread('Walking.wav');
if wav_Fs ~= Fs; 
    error('Sampling frequencies must be the same');
end

% Split STEREO to MONO, if necessary:
xR = walk(:, 1);
xL = walk(:, 1);

angleWalkLeft  = 19;
angleWalkRight = 7;

walkLeft  = [conv(walk, HRIR_set_R(angleWalkLeft,  :)), conv(walk, HRIR_set_L(angleWalkRight, :))];
walkRight = [conv(walk, HRIR_set_L(angleWalkRight, :)), conv(walk, HRIR_set_R(angleWalkLeft,  :))];

crossFadeLeft  = [linspace(1,0, length(walkLeft));linspace(1,0, length(walkLeft))]';
crossFadeRight = [linspace(0,1, length(walkRight));linspace(0,1,length(walkRight))]';

leftWalk  = walkLeft.*crossFadeLeft;
rightWalk = walkRight.*crossFadeRight;

walkSum = leftWalk + rightWalk;

% To play, type "sound(walkSum, Fs)" into command window.
audiowrite('Walk_Spatialised.wav',walkSum, wav_Fs); 
