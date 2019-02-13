-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_ch_est.vhd
-- Created: 2019-02-08 23:33:52
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_src_ch_est
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/ch_est
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ZynqBF_2t_ip_src_ZynqBF_2tx_fpga_pkg.ALL;

ENTITY ZynqBF_2t_ip_src_ch_est IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        est_rst                           :   IN    std_logic;  -- reset estimator
        rx                                :   IN    vector_of_std_logic_vector16(0 TO 1);  -- sfix16_En15 [2]
        gs1                               :   IN    vector_of_std_logic_vector16(0 TO 1);  -- sfix16_En15 [2]
        gs2                               :   IN    vector_of_std_logic_vector16(0 TO 1);  -- sfix16_En15 [2]
        gs_sel                            :   IN    std_logic_vector(0 TO 1);  -- boolean [2]
        en                                :   IN    std_logic;
        step_in                           :   IN    std_logic;
        ch1_i                             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        ch1_q                             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        ch2_i                             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        ch2_q                             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        est_done                          :   OUT   std_logic;
        step_out                          :   OUT   std_logic;
        probe_ch1i                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        probe_ch1q                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        probe_ch1r                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En14
        );
END ZynqBF_2t_ip_src_ch_est;


ARCHITECTURE rtl OF ZynqBF_2t_ip_src_ch_est IS

  -- Component Declarations
  COMPONENT ZynqBF_2t_ip_src_Detect_Change
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          U                               :   IN    std_logic;
          Y                               :   OUT   std_logic
          );
  END COMPONENT;

  -- COMPONENT ZynqBF_2t_ip_src_select_inputs_block
  --   PORT( en1                             :   IN    std_logic;
  --         en2                             :   IN    std_logic;
  --         in1                             :   IN    vector_of_std_logic_vector16(0 TO 1);  -- sfix16_En15 [2]
  --         in2                             :   IN    vector_of_std_logic_vector16(0 TO 1);  -- sfix16_En15 [2]
  --         y                               :   OUT   vector_of_std_logic_vector16(0 TO 1)  -- sfix16_En15 [2]
  --         );
  -- END COMPONENT;

  COMPONENT ZynqBF_2t_ip_src_calc_inverse
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          din                             :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
          en                              :   IN    std_logic;
          dout                            :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En14
          dval                            :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT ZynqBF_2t_ip_src_local_fsm
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          nr_done                         :   IN    std_logic;
          dp_done                         :   IN    std_logic;
          en_dp                           :   OUT   std_logic;
          en_nr                           :   OUT   std_logic;
          en_est                          :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT ZynqBF_2t_ip_src_update_csi
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          in_i                            :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          in_q                            :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          pd1                             :   IN    std_logic;
          pd2                             :   IN    std_logic;
          en                              :   IN    std_logic;
          ch1_i                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          ch1_q                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          ch2_i                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          ch2_q                           :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En15
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : ZynqBF_2t_ip_src_Detect_Change
    USE ENTITY work.ZynqBF_2t_ip_src_Detect_Change(rtl);

  -- FOR ALL : ZynqBF_2t_ip_src_select_inputs_block
  --   USE ENTITY work.ZynqBF_2t_ip_src_select_inputs_block(rtl);

  FOR ALL : ZynqBF_2t_ip_src_calc_inverse
    USE ENTITY work.ZynqBF_2t_ip_src_calc_inverse(rtl);

  FOR ALL : ZynqBF_2t_ip_src_local_fsm
    USE ENTITY work.ZynqBF_2t_ip_src_local_fsm(rtl);

  FOR ALL : ZynqBF_2t_ip_src_update_csi
    USE ENTITY work.ZynqBF_2t_ip_src_update_csi(rtl);

  -- Signals
  SIGNAL Delay19_out1                     : std_logic;
  SIGNAL Delay6_out1                      : std_logic;
  SIGNAL Detect_Change_out1               : std_logic;
  SIGNAL start_in                         : std_logic;
  SIGNAL Delay7_out1                      : std_logic_vector(0 TO 1);  -- boolean [2]
  SIGNAL gs1_signed                       : vector_of_signed16(0 TO 1);  -- sfix16_En15 [2]
  SIGNAL gs2_signed                       : vector_of_signed16(0 TO 1);  -- sfix16_En15 [2]
  SIGNAL Delay8_out1                      : vector_of_signed16(0 TO 1);  -- sfix16_En15 [2]
  SIGNAL Delay8_out1_1                    : vector_of_std_logic_vector16(0 TO 1);  -- ufix16 [2]
  SIGNAL Delay9_out1                      : vector_of_signed16(0 TO 1);  -- sfix16_En15 [2]
  SIGNAL Delay9_out1_1                    : vector_of_std_logic_vector16(0 TO 1);  -- ufix16 [2]
  SIGNAL y                                : vector_of_std_logic_vector16(0 TO 1);  -- ufix16 [2]
  SIGNAL a                                : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL s                                : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL b                                : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL s_1                              : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL cnt_reset                        : std_logic;
  SIGNAL vin                              : std_logic;
  SIGNAL HDL_Counter_out1                 : unsigned(15 DOWNTO 0);  -- uint16
  SIGNAL Compare_To_Constant_out1         : std_logic;
  SIGNAL dp_done                          : std_logic;
  SIGNAL mac_bb_not1_out                  : std_logic;
  SIGNAL switch_compare_1                 : std_logic;
  SIGNAL mac_bb_input_mux_out             : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mac_bb_multiply_out              : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL mac_bb_and1_out                  : std_logic;
  SIGNAL switch_compare_1_1               : std_logic;
  SIGNAL s_2                              : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_bb_add_fb_in                 : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_bb_add_add_temp              : signed(46 DOWNTO 0);  -- sfix47_En30
  SIGNAL mac_bb_multiplyAdd_out           : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_aa_not1_out                  : std_logic;
  SIGNAL switch_compare_1_2               : std_logic;
  SIGNAL mac_aa_input_mux_out             : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mac_aa_multiply_out              : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL mac_aa_and1_out                  : std_logic;
  SIGNAL switch_compare_1_3               : std_logic;
  SIGNAL s_3                              : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_aa_add_fb_in                 : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_aa_add_add_temp              : signed(46 DOWNTO 0);  -- sfix47_En30
  SIGNAL mac_aa_multiplyAdd_out           : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Sum_out1                         : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL local_fsm_out2                   : std_logic;
  SIGNAL calc_inverse_out1                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL nr_done                          : std_logic;
  SIGNAL local_fsm_out1                   : std_logic;
  SIGNAL local_fsm_out3                   : std_logic;
  SIGNAL mac_ac_and1_out                  : std_logic;
  SIGNAL switch_compare_1_4               : std_logic;
  SIGNAL mac_ac_not1_out                  : std_logic;
  SIGNAL switch_compare_1_5               : std_logic;
  SIGNAL s_4                              : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mac_ac_input_mux_out             : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL rx_signed                        : vector_of_signed16(0 TO 1);  -- sfix16_En15 [2]
  SIGNAL Delay11_out1                     : vector_of_signed16(0 TO 1);  -- sfix16_En15 [2]
  SIGNAL c                                : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mac_ac_multiply_out              : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL s_5                              : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_ac_add_fb_in                 : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_ac_add_add_temp              : signed(46 DOWNTO 0);  -- sfix47_En30
  SIGNAL mac_ac_multiplyAdd_out           : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_bd_and1_out                  : std_logic;
  SIGNAL switch_compare_1_6               : std_logic;
  SIGNAL mac_bd_not1_out                  : std_logic;
  SIGNAL switch_compare_1_7               : std_logic;
  SIGNAL s_6                              : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mac_bd_input_mux_out             : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL d                                : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mac_bd_multiply_out              : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL s_7                              : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_bd_add_fb_in                 : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_bd_add_add_temp              : signed(46 DOWNTO 0);  -- sfix47_En30
  SIGNAL mac_bd_multiplyAdd_out           : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Sum2_out1                        : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Delay3_out1                      : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL calc_inverse_out1_signed         : signed(31 DOWNTO 0);  -- sfix32_En14
  SIGNAL Delay2_out1                      : signed(31 DOWNTO 0);  -- sfix32_En14
  SIGNAL Product1_out1                    : signed(63 DOWNTO 0);  -- sfix64_En30
  SIGNAL mac_ad_and1_out                  : std_logic;
  SIGNAL switch_compare_1_8               : std_logic;
  SIGNAL mac_ad_not1_out                  : std_logic;
  SIGNAL switch_compare_1_9               : std_logic;
  SIGNAL s_8                              : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mac_ad_input_mux_out             : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mac_ad_multiply_out              : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL s_9                              : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_ad_add_fb_in                 : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_ad_add_add_temp              : signed(46 DOWNTO 0);  -- sfix47_En30
  SIGNAL mac_ad_multiplyAdd_out           : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_bc_and1_out                  : std_logic;
  SIGNAL switch_compare_1_10              : std_logic;
  SIGNAL mac_bc_not1_out                  : std_logic;
  SIGNAL switch_compare_1_11              : std_logic;
  SIGNAL s_10                             : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mac_bc_input_mux_out             : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL mac_bc_multiply_out              : signed(31 DOWNTO 0);  -- sfix32_En30
  SIGNAL s_11                             : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_bc_add_fb_in                 : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL mac_bc_add_add_temp              : signed(46 DOWNTO 0);  -- sfix47_En30
  SIGNAL mac_bc_multiplyAdd_out           : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Sum1_out1                        : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Delay1_out1                      : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Product_out1                     : signed(63 DOWNTO 0);  -- sfix64_En30
  SIGNAL Product1_out1_1                  : signed(63 DOWNTO 0);  -- sfix64_En30
  SIGNAL Product1_out1_2                  : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Product_out1_1                   : signed(63 DOWNTO 0);  -- sfix64_En30
  SIGNAL Product_out1_2                   : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay7_out1_0                    : std_logic;
  SIGNAL Delay17_out1                     : std_logic;
  SIGNAL Delay7_out1_1                    : std_logic;
  SIGNAL Delay18_out1                     : std_logic;
  SIGNAL Delay12_reg                      : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL Delay12_out1                     : std_logic;
  SIGNAL update_csi_out1                  : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL update_csi_out2                  : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL update_csi_out3                  : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL update_csi_out4                  : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL update_csi_out1_signed           : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay13_out1                     : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL update_csi_out2_signed           : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay14_out1                     : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL update_csi_out3_signed           : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay15_out1                     : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL update_csi_out4_signed           : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay16_out1                     : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Logical_Operator4_out1           : std_logic;
  SIGNAL Delay20_out1                     : std_logic;
  SIGNAL ac_out                           : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL bd_out                           : signed(31 DOWNTO 0);  -- sfix32_En16

  ATTRIBUTE use_dsp48 : string;

  ATTRIBUTE use_dsp48 OF mac_bb_multiply_out : SIGNAL IS "yes";
  ATTRIBUTE use_dsp48 OF mac_aa_multiply_out : SIGNAL IS "yes";
  ATTRIBUTE use_dsp48 OF mac_ac_multiply_out : SIGNAL IS "yes";
  ATTRIBUTE use_dsp48 OF mac_bd_multiply_out : SIGNAL IS "yes";
  ATTRIBUTE use_dsp48 OF Product1_out1 : SIGNAL IS "yes";
  ATTRIBUTE use_dsp48 OF mac_ad_multiply_out : SIGNAL IS "yes";
  ATTRIBUTE use_dsp48 OF mac_bc_multiply_out : SIGNAL IS "yes";
  ATTRIBUTE use_dsp48 OF Product_out1 : SIGNAL IS "yes";

BEGIN
  u_Detect_Change : ZynqBF_2t_ip_src_Detect_Change
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              U => Delay19_out1,
              Y => Detect_Change_out1
              );

  -- u_select_inputs : ZynqBF_2t_ip_src_select_inputs_block
  --   PORT MAP( en1 => Delay7_out1(0),
  --             en2 => Delay7_out1(1),
  --             in1 => Delay8_out1_1,  -- sfix16_En15 [2]
  --             in2 => Delay9_out1_1,  -- sfix16_En15 [2]
  --             y => y  -- sfix16_En15 [2]
  --            );
  
  y <=
    Delay8_out1_1 when Delay7_out1 = "01" else
    Delay9_out1_1 when Delay7_out1 = "10" else
    to_signed(16#0000#, 16);

  u_calc_inverse : ZynqBF_2t_ip_src_calc_inverse
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              din => std_logic_vector(Sum_out1),  -- sfix32_En16
              en => local_fsm_out2,
              dout => calc_inverse_out1,  -- sfix32_En14
              dval => nr_done
              );

  u_local_fsm : ZynqBF_2t_ip_src_local_fsm
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nr_done => nr_done,
              dp_done => dp_done,
              en_dp => local_fsm_out1,
              en_nr => local_fsm_out2,
              en_est => local_fsm_out3
              );

  u_update_csi : ZynqBF_2t_ip_src_update_csi
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              in_i => std_logic_vector(Product1_out1_2),  -- sfix16_En15
              in_q => std_logic_vector(Product_out1_2),  -- sfix16_En15
              pd1 => Delay17_out1,
              pd2 => Delay18_out1,
              en => Delay12_out1,
              ch1_i => update_csi_out1,  -- sfix16_En15
              ch1_q => update_csi_out2,  -- sfix16_En15
              ch2_i => update_csi_out3,  -- sfix16_En15
              ch2_q => update_csi_out4  -- sfix16_En15
              );

  Delay19_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay19_out1 <= '0';
      ELSIF enb = '1' THEN
        Delay19_out1 <= en;
      END IF;
    END IF;
  END PROCESS Delay19_process;


  Delay6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay6_out1 <= '0';
      ELSIF enb = '1' THEN
        Delay6_out1 <= step_in;
      END IF;
    END IF;
  END PROCESS Delay6_process;


  start_in <= Detect_Change_out1 AND Delay19_out1;

  Delay7_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay7_out1 <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay7_out1 <= gs_sel;
      END IF;
    END IF;
  END PROCESS Delay7_process;


  outputgen4: FOR k IN 0 TO 1 GENERATE
    gs1_signed(k) <= signed(gs1(k));
  END GENERATE;

  outputgen3: FOR k IN 0 TO 1 GENERATE
    gs2_signed(k) <= signed(gs2(k));
  END GENERATE;

  Delay8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay8_out1 <= (OTHERS => to_signed(16#0000#, 16));
      ELSIF enb = '1' THEN
        Delay8_out1 <= gs1_signed;
      END IF;
    END IF;
  END PROCESS Delay8_process;


  outputgen2: FOR k IN 0 TO 1 GENERATE
    Delay8_out1_1(k) <= std_logic_vector(Delay8_out1(k));
  END GENERATE;

  Delay9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay9_out1 <= (OTHERS => to_signed(16#0000#, 16));
      ELSIF enb = '1' THEN
        Delay9_out1 <= gs2_signed;
      END IF;
    END IF;
  END PROCESS Delay9_process;


  outputgen1: FOR k IN 0 TO 1 GENERATE
    Delay9_out1_1(k) <= std_logic_vector(Delay9_out1(k));
  END GENERATE;

  a <= signed(y(0));

  s <= to_signed(16#0000#, 16);

  b <= signed(y(1));

  s_1 <= to_signed(16#0000#, 16);

  cnt_reset <=  NOT Delay19_out1;

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 4095
  HDL_Counter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        HDL_Counter_out1 <= to_unsigned(16#0000#, 16);
      ELSIF enb = '1' THEN
        IF cnt_reset = '1' THEN 
          HDL_Counter_out1 <= to_unsigned(16#0000#, 16);
        ELSIF vin = '1' THEN 
          IF HDL_Counter_out1 >= to_unsigned(16#0FFF#, 16) THEN 
            HDL_Counter_out1 <= to_unsigned(16#0000#, 16);
          ELSE 
            HDL_Counter_out1 <= HDL_Counter_out1 + to_unsigned(16#0001#, 16);
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS HDL_Counter_process;


  
  Compare_To_Constant_out1 <= '1' WHEN HDL_Counter_out1 = to_unsigned(16#0FFF#, 16) ELSE
      '0';

  dp_done <= Compare_To_Constant_out1 AND vin;

  mac_bb_not1_out <=  NOT vin;

  
  switch_compare_1 <= '1' WHEN mac_bb_not1_out > '0' ELSE
      '0';

  
  mac_bb_input_mux_out <= b WHEN switch_compare_1 = '0' ELSE
      s_1;

  mac_bb_multiply_out <= mac_bb_input_mux_out * b;

  mac_bb_and1_out <= vin AND start_in;

  
  switch_compare_1_1 <= '1' WHEN mac_bb_and1_out > '0' ELSE
      '0';

  
  mac_bb_add_fb_in <= s_2 WHEN switch_compare_1_1 = '0' ELSE
      to_signed(0, 32);

  mac_bb_add_add_temp <= (resize(mac_bb_add_fb_in & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 47)) + (resize(mac_bb_multiply_out, 47));
  mac_bb_multiplyAdd_out <= mac_bb_add_add_temp(45 DOWNTO 14);

  mac_bb_delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' est_rst = '1' THEN
        s_2 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        s_2 <= mac_bb_multiplyAdd_out;
      END IF;
    END IF;
  END PROCESS mac_bb_delay_process;


  mac_aa_not1_out <=  NOT vin;

  
  switch_compare_1_2 <= '1' WHEN mac_aa_not1_out > '0' ELSE
      '0';

  
  mac_aa_input_mux_out <= a WHEN switch_compare_1_2 = '0' ELSE
      s;

  mac_aa_multiply_out <= mac_aa_input_mux_out * a;

  mac_aa_and1_out <= vin AND start_in;

  
  switch_compare_1_3 <= '1' WHEN mac_aa_and1_out > '0' ELSE
      '0';

  
  mac_aa_add_fb_in <= s_3 WHEN switch_compare_1_3 = '0' ELSE
      to_signed(0, 32);

  mac_aa_add_add_temp <= (resize(mac_aa_add_fb_in & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 47)) + (resize(mac_aa_multiply_out, 47));
  mac_aa_multiplyAdd_out <= mac_aa_add_add_temp(45 DOWNTO 14);

  mac_aa_delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' or est_rst = '1' THEN
        s_3 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        s_3 <= mac_aa_multiplyAdd_out;
      END IF;
    END IF;
  END PROCESS mac_aa_delay_process;


  Sum_out1 <= s_3 + s_2;

  vin <= local_fsm_out1 AND (Delay19_out1 AND Delay6_out1);

  mac_ac_and1_out <= vin AND start_in;

  
  switch_compare_1_4 <= '1' WHEN mac_ac_and1_out > '0' ELSE
      '0';

  mac_ac_not1_out <=  NOT vin;

  
  switch_compare_1_5 <= '1' WHEN mac_ac_not1_out > '0' ELSE
      '0';

  s_4 <= to_signed(16#0000#, 16);

  
  mac_ac_input_mux_out <= a WHEN switch_compare_1_5 = '0' ELSE
      s_4;

  outputgen: FOR k IN 0 TO 1 GENERATE
    rx_signed(k) <= signed(rx(k));
  END GENERATE;

  Delay11_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay11_out1 <= (OTHERS => to_signed(16#0000#, 16));
      ELSIF enb = '1' THEN
        Delay11_out1 <= rx_signed;
      END IF;
    END IF;
  END PROCESS Delay11_process;


  c <= Delay11_out1(0);

  mac_ac_multiply_out <= mac_ac_input_mux_out * c;

  
  mac_ac_add_fb_in <= s_5 WHEN switch_compare_1_4 = '0' ELSE
      to_signed(0, 32);

  mac_ac_add_add_temp <= (resize(mac_ac_add_fb_in & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 47)) + (resize(mac_ac_multiply_out, 47));
  mac_ac_multiplyAdd_out <= mac_ac_add_add_temp(45 DOWNTO 14);

  mac_ac_delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' or est_rst = '1' THEN
        s_5 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        s_5 <= mac_ac_multiplyAdd_out;
      END IF;
    END IF;
  END PROCESS mac_ac_delay_process;


  mac_bd_and1_out <= vin AND start_in;

  
  switch_compare_1_6 <= '1' WHEN mac_bd_and1_out > '0' ELSE
      '0';

  mac_bd_not1_out <=  NOT vin;

  
  switch_compare_1_7 <= '1' WHEN mac_bd_not1_out > '0' ELSE
      '0';

  s_6 <= to_signed(16#0000#, 16);

  
  mac_bd_input_mux_out <= b WHEN switch_compare_1_7 = '0' ELSE
      s_6;

  d <= Delay11_out1(1);

  mac_bd_multiply_out <= mac_bd_input_mux_out * d;

  
  mac_bd_add_fb_in <= s_7 WHEN switch_compare_1_6 = '0' ELSE
      to_signed(0, 32);

  mac_bd_add_add_temp <= (resize(mac_bd_add_fb_in & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 47)) + (resize(mac_bd_multiply_out, 47));
  mac_bd_multiplyAdd_out <= mac_bd_add_add_temp(45 DOWNTO 14);

  mac_bd_delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' or est_rst = '1' THEN
        s_7 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        s_7 <= mac_bd_multiplyAdd_out;
      END IF;
    END IF;
  END PROCESS mac_bd_delay_process;


  Sum2_out1 <= s_5 + s_7;

  Delay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay3_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay3_out1 <= Sum2_out1;
      END IF;
    END IF;
  END PROCESS Delay3_process;


  calc_inverse_out1_signed <= signed(calc_inverse_out1);

  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay2_out1 <= calc_inverse_out1_signed;
      END IF;
    END IF;
  END PROCESS Delay2_process;


  Product1_out1 <= Delay3_out1 * Delay2_out1;

  mac_ad_and1_out <= vin AND start_in;

  
  switch_compare_1_8 <= '1' WHEN mac_ad_and1_out > '0' ELSE
      '0';

  mac_ad_not1_out <=  NOT vin;

  
  switch_compare_1_9 <= '1' WHEN mac_ad_not1_out > '0' ELSE
      '0';

  s_8 <= to_signed(16#0000#, 16);

  
  mac_ad_input_mux_out <= a WHEN switch_compare_1_9 = '0' ELSE
      s_8;

  mac_ad_multiply_out <= mac_ad_input_mux_out * d;

  
  mac_ad_add_fb_in <= s_9 WHEN switch_compare_1_8 = '0' ELSE
      to_signed(0, 32);

  mac_ad_add_add_temp <= (resize(mac_ad_add_fb_in & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 47)) + (resize(mac_ad_multiply_out, 47));
  mac_ad_multiplyAdd_out <= mac_ad_add_add_temp(45 DOWNTO 14);

  mac_ad_delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' or est_rst = '1' THEN
        s_9 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        s_9 <= mac_ad_multiplyAdd_out;
      END IF;
    END IF;
  END PROCESS mac_ad_delay_process;


  mac_bc_and1_out <= vin AND start_in;

  
  switch_compare_1_10 <= '1' WHEN mac_bc_and1_out > '0' ELSE
      '0';

  mac_bc_not1_out <=  NOT vin;

  
  switch_compare_1_11 <= '1' WHEN mac_bc_not1_out > '0' ELSE
      '0';

  s_10 <= to_signed(16#0000#, 16);

  
  mac_bc_input_mux_out <= b WHEN switch_compare_1_11 = '0' ELSE
      s_10;

  mac_bc_multiply_out <= mac_bc_input_mux_out * c;

  
  mac_bc_add_fb_in <= s_11 WHEN switch_compare_1_10 = '0' ELSE
      to_signed(0, 32);

  mac_bc_add_add_temp <= (resize(mac_bc_add_fb_in & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 47)) + (resize(mac_bc_multiply_out, 47));
  mac_bc_multiplyAdd_out <= mac_bc_add_add_temp(45 DOWNTO 14);

  mac_bc_delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' or est_rst = '1' THEN
        s_11 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        s_11 <= mac_bc_multiplyAdd_out;
      END IF;
    END IF;
  END PROCESS mac_bc_delay_process;


  Sum1_out1 <= s_9 - s_11;

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay1_out1 <= Sum1_out1;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  Product_out1 <= Delay1_out1 * Delay2_out1;

  PipelineRegister1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Product1_out1_1 <= to_signed(0, 64);
      ELSIF enb = '1' THEN
        Product1_out1_1 <= Product1_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister1_process;


  Product1_out1_2 <= Product1_out1_1(30 DOWNTO 15);

  PipelineRegister_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Product_out1_1 <= to_signed(0, 64);
      ELSIF enb = '1' THEN
        Product_out1_1 <= Product_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister_process;


  Product_out1_2 <= Product_out1_1(30 DOWNTO 15);

  Delay7_out1_0 <= Delay7_out1(0);

  Delay17_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay17_out1 <= '0';
      ELSIF enb = '1' THEN
        Delay17_out1 <= Delay7_out1_0;
      END IF;
    END IF;
  END PROCESS Delay17_process;


  Delay7_out1_1 <= Delay7_out1(1);

  Delay18_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay18_out1 <= '0';
      ELSIF enb = '1' THEN
        Delay18_out1 <= Delay7_out1_1;
      END IF;
    END IF;
  END PROCESS Delay18_process;


  Delay12_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay12_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay12_reg(0) <= local_fsm_out3;
        Delay12_reg(1) <= Delay12_reg(0);
      END IF;
    END IF;
  END PROCESS Delay12_process;

  Delay12_out1 <= Delay12_reg(1);

  update_csi_out1_signed <= signed(update_csi_out1);

  Delay13_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay13_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay13_out1 <= update_csi_out1_signed;
      END IF;
    END IF;
  END PROCESS Delay13_process;


  ch1_i <= std_logic_vector(Delay13_out1);

  update_csi_out2_signed <= signed(update_csi_out2);

  Delay14_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay14_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay14_out1 <= update_csi_out2_signed;
      END IF;
    END IF;
  END PROCESS Delay14_process;


  ch1_q <= std_logic_vector(Delay14_out1);

  update_csi_out3_signed <= signed(update_csi_out3);

  Delay15_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay15_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay15_out1 <= update_csi_out3_signed;
      END IF;
    END IF;
  END PROCESS Delay15_process;


  ch2_i <= std_logic_vector(Delay15_out1);

  update_csi_out4_signed <= signed(update_csi_out4);

  Delay16_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay16_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay16_out1 <= update_csi_out4_signed;
      END IF;
    END IF;
  END PROCESS Delay16_process;


  ch2_q <= std_logic_vector(Delay16_out1);

  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        est_done <= '0';
      ELSIF enb = '1' THEN
        est_done <= Delay12_out1;
      END IF;
    END IF;
  END PROCESS Delay_process;


  Logical_Operator4_out1 <= start_in OR vin;

  Delay20_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay20_out1 <= '0';
      ELSIF enb = '1' THEN
        -- Delay20_out1 <= Logical_Operator4_out1;
        Delay20_out1 <= vin;
      END IF;
    END IF;
  END PROCESS Delay20_process;


  probe_ch1i <= std_logic_vector(Delay3_out1);

  probe_ch1q <= std_logic_vector(Delay1_out1);

  probe_ch1r <= std_logic_vector(Delay2_out1);

  step_out <= Delay20_out1;

END rtl;

