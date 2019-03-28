% if strcmp(computer, 'PCWIN64')
%     load('.\data\GenGoldSeq_4k.mat');
% else
%     load('./data/GenGoldSeq_4k.mat');
% end

load(fullfile('data', 'goldSeq_4k.mat'));

%% Arrange rx inputs
% gs1i = real(goldSeq_4k(:,1)); gs1q = imag(goldSeq_4k(:,1));
% gs2i = real(goldSeq_4k(:,2)); gs2q = iamg(goldSeq_4k(:,2));
% gs3i = real(goldSeq_4k(:,3)); gs3q = imag(goldSeq_4k(:,3));
% gs4i = real(goldSeq_4k(:,4)); gs4q = iamg(goldSeq_4k(:,4));

gs1 = goldSeq_4k(:,1);
gs2 = goldSeq_4k(:,2);
gs3 = goldSeq_4k(:,3);
gs4 = goldSeq_4k(:,4);

rx1_data = zeros(20e3, 1);
rx1_rand = zeros(20e3,1);
rx1_data(10:10+numel(gs1)-1) = gs1;
n1_rand = numel(10+numel(gs1):numel(rx1_data));
rx1_rand(10+numel(gs1):numel(rx1)) = 0.45*rand(n1_rand,1) + 1i*0.45*rand(n1_rand,1);

rx1 = rx1_data + rx1_rand;

rx2_data = zeros(20e3, 1);
rx2_rand = zeros(20e3,1);
rx2_data(23:23+numel(gs2)-1) = gs2;
n2_rand = numel(23+numel(gs2):numel(rx2_data));
rx2_rand(23+numel(gs2):numel(rx2_data)) = 0.45*rand(n2_rand,1) + 1i*0.45*rand(n2_rand,1);

rx2 = rx2_data + rx2_rand;

rx = (rx1+rx2);
rx_i_in = real(rx);
rx_q_in = imag(rx);

%% File name
file_i = fullfile('simulation','rx_test_i.txt');
file_q = fullfile('simulation','rx_test_q.txt');

%% Extract rxi and rxq from .mat file data
rxi_fi = fi(rx_i_in,1,16,15);
rxq_fi = fi(rx_q_in,1,16,15);

%% Convert to binary
rxi = bin(rxi_fi);
rxq = bin(rxq_fi);

%% Loop through and write to file
nlines = numel(rxi_fi);

fidi = fopen(file_i, 'w');
fidq = fopen(file_q, 'w');

for i = 1:nlines
    fprintf(fidi,[rxi(i,:) '\n']);
    fprintf(fidq,[rxq(i,:) '\n']);
end

fclose(fidi);
fclose(fidq);