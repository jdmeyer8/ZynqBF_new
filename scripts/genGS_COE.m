%% A script for generating files containing the VHDL description of gold sequence constants

%% File names based on what computer is running the script
% if strcmp(computer, 'PCWIN64')
%     fname1 = '.\data\GoldSeqConsts1.vhd';
%     fname2 = '.\data\GoldSeqConsts2.vhd';
%     toload = '.\data\goldSeq_4k.mat';
% else
%     fname1 = './data/GoldSeqConsts1.vhd';
%     fname2 = './data/GoldSeqConsts2.vhd';
%     toload = './data/goldSeq_4k.mat';
% end

fname1 = fullfile('hdl_prj','vivado_ip_prj','data','gsram1.coe');
fname2 = fullfile('hdl_prj','vivado_ip_prj','data','gsram2.coe');
fname3 = fullfile('hdl_prj','vivado_ip_prj','data','gsram3.coe');
fname4 = fullfile('hdl_prj','vivado_ip_prj','data','gsram4.coe');
fname5 = fullfile('hdl_prj','vivado_ip_prj','data','gsram5.coe');
toload = fullfile('data','goldSeq_4k_2.mat');

%% Load gold sequences and convert to fixed point (16 bits, 15 decimal bits)
load(toload);
gs1 = fi(real(goldSeq_4k(:,1)), 1, 16, 15);
gs2 = fi(real(goldSeq_4k(:,2)), 1, 16, 15);
gs3 = fi(real(goldSeq_4k(:,3)), 1, 16, 15);
gs4 = fi(real(goldSeq_4k(:,4)), 1, 16, 15);
gs5 = fi(real(goldSeq_4k(:,5)), 1, 16, 15);

%% Open files for writing
fid1 = fopen(fname1, 'w');
fid2 = fopen(fname2, 'w');
fid3 = fopen(fname3, 'w');
fid4 = fopen(fname4, 'w');
fid5 = fopen(fname5, 'w');

%% Loop through - write each lut_data one-by-one
fprintf(fid1, 'memory_initialization_radix=2;\n');
fprintf(fid2, 'memory_initialization_radix=2;\n');
fprintf(fid3, 'memory_initialization_radix=2;\n');
fprintf(fid4, 'memory_initialization_radix=2;\n');
fprintf(fid5, 'memory_initialization_radix=2;\n');

fprintf(fid1, 'memory_initialization_vector=\n');
fprintf(fid2, 'memory_initialization_vector=\n');
fprintf(fid3, 'memory_initialization_vector=\n');
fprintf(fid4, 'memory_initialization_vector=\n');
fprintf(fid5, 'memory_initialization_vector=\n');

for i = 1:64:4096    
    str1 = '';
    str2 = '';
    str3 = '';
    str4 = '';
    str5 = '';
    for j = i:i+63
        str1 = [bin(gs1(j)) str1];
        str2 = [bin(gs2(j)) str2];
        str3 = [bin(gs3(j)) str3];
        str4 = [bin(gs4(j)) str4];
        str5 = [bin(gs5(j)) str5];
    end
    if (i == 4033)
        fprintf(fid1, [str1 ';']);
        fprintf(fid2, [str2 ';']);
        fprintf(fid3, [str3 ';']);
        fprintf(fid4, [str4 ';']);
        fprintf(fid5, [str5 ';']);
    else
        fprintf(fid1, [str1 ',\n']);
        fprintf(fid2, [str2 ',\n']);
        fprintf(fid3, [str3 ',\n']);
        fprintf(fid4, [str4 ',\n']);
        fprintf(fid5, [str5 ',\n']);
    end
end

% fprintf(fid1, '-----------------------------------------------------------------\n');
% fprintf(fid2, '-----------------------------------------------------------------\n');
% fprintf(fid1, '-----------------------------------------------------------------\n');
% fprintf(fid2, '-----------------------------------------------------------------\n');

% fprintf(fid1, '\nGS1 q LUTs\n\n');
% fprintf(fid2, '\nGS2 q LUTs\n\n');
% 
% for i = 1:64
%     fprintf(fid1, ['constant lut_gs1q_data_' sprintf('%d', i) ' : vector_of_signed16(0 to 63) := \n']);
%     fprintf(fid2, ['constant lut_gs2q_data_' sprintf('%d', i) ' : vector_of_signed16(0 to 63) := \n']);
%     for j = i:64:4096
%         if (j < 65)
%             fprintf(fid1, '   (signed("%s"),\n', bin(gs1q(j)));
%             fprintf(fid2, '   (signed("%s"),\n', bin(gs2q(j)));
%         elseif (j > 4032)
%             fprintf(fid1, '    signed("%s"));\n', bin(gs1q(j)));
%             fprintf(fid2, '    signed("%s"));\n', bin(gs2q(j)));
%         else
%             fprintf(fid1, '    signed("%s"),\n', bin(gs1q(j)));
%             fprintf(fid2, '    signed("%s"),\n', bin(gs2q(j)));
%         end
%     end
%     fprintf(fid1, '\n');
%     fprintf(fid2, '\n');
% end

fclose(fid1);
fclose(fid2);
fclose(fid3);
fclose(fid4);
fclose(fid5);