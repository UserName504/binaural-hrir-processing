function [walkSum] = WalkPan(walk)
load HRIRs_0el_IRC_subject59
%WALKPAN Summary of this function goes here
%   Detailed explanation goes here
xR = walk(:, 1); % Splits a stereo signal into mono, if necessary.
xL = walk(:, 1);

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