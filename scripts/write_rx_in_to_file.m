% if strcmp(computer, 'PCWIN64')
%     load('.\data\GenGoldSeq_4k.mat');
% else
%     load('./data/GenGoldSeq_4k.mat');
% end

load(fullfile('data', 'goldSeq_4k_2.mat'));
test = helperMUBeamformInitGoldSeq;

%% Arrange rx inputs
% gs1i = real(goldSeq_4k(:,1)); gs1q = imag(goldSeq_4k(:,1));
% gs2i = real(goldSeq_4k(:,2)); gs2q = iamg(goldSeq_4k(:,2));
% gs3i = real(goldSeq_4k(:,3)); gs3q = imag(goldSeq_4k(:,3));
% gs4i = real(goldSeq_4k(:,4)); gs4q = iamg(goldSeq_4k(:,4));

gs1 = goldSeq_4k(:,1);
gs2 = goldSeq_4k(:,2);
gs3 = goldSeq_4k(:,3);
gs4 = goldSeq_4k(:,4);
gs5 = goldSeq_4k(:,5);

rx1_ind = 10;
rx1_data = zeros(20e3, 1);
rx1_rand = zeros(20e3,1);
rx1_data(rx1_ind:rx1_ind+numel(gs1)-1) = gs1;
n1_rand = numel(rx1_ind+numel(gs1):numel(rx1_data));
rx1_rand(rx1_ind+numel(gs1):numel(rx1_data)) = 0.45*rand(n1_rand,1) + 1i*0.45*rand(n1_rand,1);
rx1 = rx1_data;
% rx1 = rx1_data + rx1_rand;

rx2_ind = 10;
rx2_data = zeros(20e3, 1);
rx2_rand = zeros(20e3,1);
rx2_data(rx2_ind:rx2_ind+numel(gs2)-1) = gs2;
n2_rand = numel(rx2_ind+numel(gs2):numel(rx2_data));
rx2_rand(rx2_ind+numel(gs2):numel(rx2_data)) = 0.45*rand(n2_rand,1) + 1i*0.45*rand(n2_rand,1);
rx2 = rx2_data;
% rx2 = rx2_data + rx2_rand;

rx3_ind = 6;
rx3_data = zeros(20e3, 1);
rx3_rand = zeros(20e3,1);
rx3_data(rx3_ind:rx3_ind+numel(gs3)-1) = gs3;
n3_rand = numel(rx3_ind+numel(gs3):numel(rx3_data));
rx3_rand(rx3_ind+numel(gs3):numel(rx3_data)) = 0.45*rand(n3_rand,1) + 1i*0.45*rand(n3_rand,1);
rx3 = rx3_data;
% rx3 = rx3_data + rx3_rand;

rx4_ind = 13;
rx4_data = zeros(20e3, 1);
rx4_rand = zeros(20e3,1);
rx4_data(rx4_ind:rx4_ind+numel(gs4)-1) = gs4;
n4_rand = numel(rx4_ind+numel(gs4):numel(rx4_data));
rx4_rand(rx4_ind+numel(gs4):numel(rx4_data)) = 0.45*rand(n4_rand,1) + 1i*0.45*rand(n4_rand,1);
rx4 = rx4_data;
% rx4 = rx4_data + rx4_rand;

rx5_ind = 19;
rx5_data = zeros(20e3, 1);
rx5_rand = zeros(20e3,1);
rx5_data(rx5_ind:rx5_ind+numel(gs5)-1) = gs5;
n5_rand = numel(rx5_ind+numel(gs5):numel(rx5_data));
rx5_rand(rx5_ind+numel(gs5):numel(rx5_data)) = 0.45*rand(n5_rand,1) + 1i*0.45*rand(n5_rand,1);
rx5 = rx5_data;
% rx5 = rx5_data + rx5_rand;

% noise = zeros(20e3,1);
% noise(rx1_ind+numel(gs1):numel(rx1_data)) = test(1:n1_rand,4);

rx1 = [zeros(10,1); gs1; zeros(100,1); gs1; zeros(100,1)];
rx2 = [zeros(10,1); gs2; zeros(100,1); gs2; zeros(100,1)];

rx = (rx1+rx2); %+0.8*rx3+0.8*rx4+0.8*rx5) + 0.8*normrnd(0,0.5,20e3,1) + 1i*0.2*normrnd(0,0.5,20e3,1);
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