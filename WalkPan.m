function [walkSum] = WalkPan(walk)

% LOAD HRIR dataset here:
load HRIRs_0el_IRC_subject59

xR = walk(:, 1); % Splits a STEREO signal into MONO, if necessary.
xL = walk(:, 1); % Splits a STEREO signal into MONO, if necessary.

angleWalkLeft = 19;
angleWalkRight = 7;

walkLeft = [conv(walk, HRIR_set_R(angleWalkLeft, :)), conv(walk, HRIR_set_L(angleWalkRight, :))];
walkRight = [conv(walk, HRIR_set_L(angleWalkRight, :)), conv(walk, HRIR_set_R(angleWalkLeft, :))];

crossFadeLeft = [linspace(1,0,length(walkLeft));linspace(1,0,length(walkLeft))]';
crossFadeRight = [linspace(0,1,length(walkRight));linspace(0,1,length(walkRight))]';

leftWalk = walkLeft.*crossFadeLeft;
rightWalk = walkRight.*crossFadeRight;

walkSum = leftWalk+rightWalk;
end
