% LOAD HRIR dataset here:
load HRIRs_0el_IRC_subject59

open  = audioread('DoorOpening.wav');
shut  = audioread('DoorClosed.wav');
alarm = audioread('Alarm.wav');
fire  = audioread('Fire.wav');
walk  = audioread('Walking.wav');
N     = 1400000;
open  = DoorOpen (open);
shut  = DoorClose(shut);
alarm = AlarmRing(alarm);
fire  = FireBurn (fire);
walk  = WalkPan  (walk);

% Zero padding, to ensure that all input signal are the same length:
open    = vertcat(open, zeros(N - length(open), 2));
walk    = vertcat(walk, zeros(N - length(walk), 2));
alarm   = vertcat(alarm, zeros(N - length(alarm), 2));
fire    = vertcat(fire, zeros(N - length(fire), 2));
shut    = vertcat(shut, zeros(N - length(shut), 2));
MixDown = open + shut + alarm + fire + walk;

normalizedOutput = zeros(N,2);

maxVolume        = max(max(abs(MixDown)));
normalizedOutput = (MixDown/maxVolume) * 0.99;

sound(normalizedOutput,44100)
audiowrite('BinauralOutput.wav',normalizedOutput, Fs);
