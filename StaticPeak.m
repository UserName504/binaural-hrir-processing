% LOAD audio input here:
[x,fs]  =audioread('Walking.wav');
x       =   x(:,1); % Extract a single channel of the input, x
fp      =   1200;
theta   =   2*pi*fp/fs;
r       =   0.995;
R       =   0.8;
N       =   length(x);
f       =   linspace(0,fs*(1-1/N),N);
b       =   [1 -2*R*cos(theta) R^2];
a       =   [1 -2*r*cos(theta) r^2];
eterm   =   exp(1j*2*pi*f/fs);
H       =   polyval(b,eterm)./polyval(a,eterm);
y       =   real(ifft(H'.*fft(x)));
y       =   0.99*y/max(abs(y)); % Normalise range to the wav format
audiowrite('Walking_Filtered.wav',y,fs); %
