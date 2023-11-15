%%
clear all
clc
%% Constants

kb = 1.381 * 10^(-23); % Constant
T = 300; % Sensor temperature
B = 20 * 10^6; % Total Bandwidth
F = 9; % Noise figure
b = 10^6; % Noise bandwidth (placeholder value)
C = 10^6; % Wanted throughput

noise = 10*log10(kb*T*b/0.001) + F; % Noise in dbm

%% Moved router to corners with overlap

load('Pr_updt.mat') % Received power with routers in the corners of the rooms

% Values from FDMA
fd = 1/3;
Td = [1/3 2/3]';
sinr = zeros(3);
Pr_W = 10.^(Pr/10)*0.001; % Received power in watts
noise = 10.^(noise/10)*0.001; % Noise in watts
% Floor 1 -> 2
sinr(3,1) = Pr_W(1,4)/(Pr_W(7,4)+noise);
sinr(3,2) = Pr_W(2,5)/(Pr_W(8,5)+noise);
sinr(3,3) = Pr_W(3,6)/(Pr_W(9,6)+noise);
% Floor 2 -> 3
sinr(2,1) = Pr_W(4,7)/(noise);
sinr(2,2) = Pr_W(5,8)/(noise);
sinr(2,3) = Pr_W(6,9)/(noise);
% Floor 3 -> Server
sinr(1,1) = Pr_W(7,10)/(Pr_W(1,10)+noise);
sinr(1,2) = Pr_W(8,10)/(Pr_W(2,10)+noise);
sinr(1,3) = Pr_W(9,10)/(Pr_W(3,10)+noise);

sinr_db = 10*log10(sinr);

log2sinr = log2(1+sinr);

log2sinr_sum = sum(log2sinr');

C_link = B * log2sinr; % Throughput for each link

spec_eff = fd * (Td(1) * log2sinr_sum(2) + Td(2) * (log2sinr_sum(1)+log2sinr_sum(3))); % throughput / bandwidth

B_min = C / spec_eff; % The minimum bandwidth for a total system > 1 Mbps

counter = sum(C_link>10^6, 'all');

dim = size(C_link);

prob = counter/(dim(1)*dim(2));
%% All nodes communicate with server on different frequencies
load('Pr.mat') % Received power with routers in the middle of each room

snr = Pr(10,:) - noise;
% % We can see here that node 1 and 3 cannot communicate with server at all

%% Per floor with overlap 
load('Pr.mat') % Received power with routers in the middle of each room

% Values from FDMA
fd = 1/3;
Td = [1/3 2/3]';
sinr = zeros(3);
Pr_W = 10.^(Pr/10)*0.001; % Received power in watts
noise = 10.^(noise/10)*0.001; % Noise in watts
% Floor 1 -> 2
sinr(3,1) = Pr_W(1,4)/(Pr_W(7,4)+noise);
sinr(3,2) = Pr_W(2,5)/(Pr_W(8,5)+noise);
sinr(3,3) = Pr_W(3,6)/(Pr_W(9,6)+noise);
% Floor 2 -> 3
sinr(2,1) = Pr_W(4,7)/(noise);
sinr(2,2) = Pr_W(5,8)/(noise);
sinr(2,3) = Pr_W(6,9)/(noise);
% Floor 3 -> Server
sinr(1,1) = Pr_W(7,10)/(Pr_W(1,10)+noise);
sinr(1,2) = Pr_W(8,10)/(Pr_W(2,10)+noise);
sinr(1,3) = Pr_W(9,10)/(Pr_W(3,10)+noise);

sinr_db = 10*log10(sinr);

log2sinr = log2(1+sinr);

log2sinr_sum = sum(log2sinr');

spec_eff = fd * (Td(1) * log2sinr_sum(2) + Td(2) * (log2sinr_sum(1)+log2sinr_sum(3))); % throughput / bandwidth

B_min = C / spec_eff; % The minimum bandwidth for a total system > 1 Mbps

C_link = B * log2sinr;

counter = sum(C_link>10^6, 'all');

dim = size(C_link);

prob = counter/(dim(1)*dim(2));

%% Per floor without time overlap !! This is a possible solution !!
load('Pr.mat') % Received power with routers in the middle of each room


% Values from FDMA
fd = 1/3;
Td = 1/3;
sinr = zeros(3);
Pr_W = 10.^(Pr/10)*0.001; % Received power in watts
noise = 10.^(noise/10)*0.001; % Noise in watts
% Floor 1 -> 2
sinr(3,1) = Pr_W(1,4)/(noise);
sinr(3,2) = Pr_W(2,5)/(noise);
sinr(3,3) = Pr_W(3,6)/(noise);
% Floor 2 -> 3
sinr(2,1) = Pr_W(4,7)/(noise);
sinr(2,2) = Pr_W(5,8)/(noise);
sinr(2,3) = Pr_W(6,9)/(noise);
% Floor 3 -> Server
sinr(1,1) = Pr_W(7,10)/(noise);
sinr(1,2) = Pr_W(8,10)/(noise);
sinr(1,3) = Pr_W(9,10)/(noise);

sinr_db = 10*log10(sinr);

log2sinr = log2(1+sinr);

log2sinr_sum = sum(log2sinr, 'all');

C_link = B * log2sinr;

spec_eff = fd * Td * log2sinr_sum; % throughput / bandwidth

B_min = C/spec_eff; % The minimum bandwidth for a total system > 1 Mbps

counter = sum(C_link>10^6, 'all');

dim = size(C_link);

prob = counter/(dim(1)*dim(2));
