-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2tx_fpga.vhd
-- Created: 2019-02-08 13:29:44
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 1.86012e-08
-- Target subsystem base rate: 1.86012e-08
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out_1      1.86012e-08
-- ce_out_0      2.38095e-06
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- rx_i_out                      ce_out_0      2.38095e-06
-- rx_q_out                      ce_out_0      2.38095e-06
-- rx_v_out                      ce_out_0      2.38095e-06
-- ch1_i                         ce_out_1      1.86012e-08
-- ch1_q                         ce_out_1      1.86012e-08
-- ch2_i                         ce_out_1      1.86012e-08
-- ch2_q                         ce_out_1      1.86012e-08
-- probe                         ce_out_1      1.86012e-08
-- probe_xcorr1                  ce_out_1      1.86012e-08
-- probe_xcorr2                  ce_out_1      1.86012e-08
-- probe_state                   ce_out_1      1.86012e-08
-- probe_ch1i                    ce_out_1      1.86012e-08
-- probe_ch1q                    ce_out_1      1.86012e-08
-- probe_ch1r                    ce_out_1      1.86012e-08
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2tx_fpga
-- Source Path: ZynqBF_2tx_fpga
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ZynqBF_2tx_fpga IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        rx_i_in                           :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        rx_q_in                           :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        rx_v_in                           :   IN    std_logic;
        ce_out_0                          :   OUT   std_logic;
        ce_out_1                          :   OUT   std_logic;
        rx_i_out                          :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        rx_q_out                          :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        rx_v_out                          :   OUT   std_logic;
        ch1_i                             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        ch1_q                             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        ch2_i                             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        ch2_q                             :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        probe                             :   OUT   std_logic_vector(14 DOWNTO 0);  -- ufix15
        probe_xcorr1                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        probe_xcorr2                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        probe_state                       :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        probe_ch1i                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        probe_ch1q                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        probe_ch1r                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En14
        );
END ZynqBF_2tx_fpga;


ARCHITECTURE rtl OF ZynqBF_2tx_fpga IS

  -- Component Declarations
  COMPONENT ZynqBF_2tx_fpga_tc
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          clk_enable                      :   IN    std_logic;
          enb                             :   OUT   std_logic;
          enb_1_1_1                       :   OUT   std_logic;
          enb_1_128_0                     :   OUT   std_logic;
          enb_1_128_1                     :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT channel_estimator
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_128_0                     :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_128_1                     :   IN    std_logic;
          enb_1_1_1                       :   IN    std_logic;
          rx_i                            :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          rx_q                            :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          rx_v                            :   IN    std_logic;
          ch1_i                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          ch1_q                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          ch2_i                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          ch2_q                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
          probe_xcorr1                    :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
          probe_xcorr2                    :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
          probe_state                     :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          probe_ch1i                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
          probe_ch1q                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
          probe_ch1r                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En14
          probe                           :   OUT   std_logic_vector(14 DOWNTO 0)  -- ufix15
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : ZynqBF_2tx_fpga_tc
    USE ENTITY work.ZynqBF_2tx_fpga_tc(rtl);

  FOR ALL : channel_estimator
    USE ENTITY work.channel_estimator(rtl);

  -- Signals
  SIGNAL enb_1_128_0                      : std_logic;
  SIGNAL enb                              : std_logic;
  SIGNAL enb_1_128_1                      : std_logic;
  SIGNAL enb_1_1_1                        : std_logic;
  SIGNAL rx_i_in_signed                   : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL rx_i                             : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay_out1                       : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL rx_q_in_signed                   : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL rx_q                             : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay1_out1                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay5_out1                      : std_logic;
  SIGNAL Delay2_out1                      : std_logic;
  SIGNAL channel_estimator_out1           : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL channel_estimator_out2           : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL channel_estimator_out3           : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL channel_estimator_out4           : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL channel_estimator_out5           : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL channel_estimator_out6           : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL channel_estimator_out7           : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL channel_estimator_out8           : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL channel_estimator_out9           : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL channel_estimator_out10          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL channel_estimator_out11          : std_logic_vector(14 DOWNTO 0);  -- ufix15
  SIGNAL channel_estimator_out1_signed    : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay8_out1                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL channel_estimator_out2_signed    : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay9_out1                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL channel_estimator_out3_signed    : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay10_out1                     : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL channel_estimator_out4_signed    : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL Delay11_out1                     : signed(15 DOWNTO 0);  -- sfix16_En15

BEGIN
  u_ZynqBF_2tx_fpga_tc : ZynqBF_2tx_fpga_tc
    PORT MAP( clk => clk,
              reset => reset,
              clk_enable => clk_enable,
              enb => enb,
              enb_1_1_1 => enb_1_1_1,
              enb_1_128_0 => enb_1_128_0,
              enb_1_128_1 => enb_1_128_1
              );

  u_channel_estimator : channel_estimator
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_128_0 => enb_1_128_0,
              enb => enb,
              enb_1_128_1 => enb_1_128_1,
              enb_1_1_1 => enb_1_1_1,
              rx_i => std_logic_vector(rx_i),  -- sfix16_En15
              rx_q => std_logic_vector(rx_q),  -- sfix16_En15
              rx_v => Delay5_out1,
              ch1_i => channel_estimator_out1,  -- sfix16_En15
              ch1_q => channel_estimator_out2,  -- sfix16_En15
              ch2_i => channel_estimator_out3,  -- sfix16_En15
              ch2_q => channel_estimator_out4,  -- sfix16_En15
              probe_xcorr1 => channel_estimator_out5,  -- sfix32_En16
              probe_xcorr2 => channel_estimator_out6,  -- sfix32_En16
              probe_state => channel_estimator_out7,  -- uint8
              probe_ch1i => channel_estimator_out8,  -- sfix32_En16
              probe_ch1q => channel_estimator_out9,  -- sfix32_En16
              probe_ch1r => channel_estimator_out10,  -- sfix32_En14
              probe => channel_estimator_out11  -- ufix15
              );

  rx_i_in_signed <= signed(rx_i_in);

  Delay3_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        rx_i <= to_signed(16#0000#, 16);
      ELSIF enb_1_128_0 = '1' THEN
        rx_i <= rx_i_in_signed;
      END IF;
    END IF;
  END PROCESS Delay3_process;


  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay_out1 <= to_signed(16#0000#, 16);
      ELSIF enb_1_128_0 = '1' THEN
        Delay_out1 <= rx_i;
      END IF;
    END IF;
  END PROCESS Delay_process;


  rx_i_out <= std_logic_vector(Delay_out1);

  rx_q_in_signed <= signed(rx_q_in);

  Delay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        rx_q <= to_signed(16#0000#, 16);
      ELSIF enb_1_128_0 = '1' THEN
        rx_q <= rx_q_in_signed;
      END IF;
    END IF;
  END PROCESS Delay4_process;


  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= to_signed(16#0000#, 16);
      ELSIF enb_1_128_0 = '1' THEN
        Delay1_out1 <= rx_q;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  rx_q_out <= std_logic_vector(Delay1_out1);

  Delay5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay5_out1 <= '0';
      ELSIF enb_1_128_0 = '1' THEN
        Delay5_out1 <= rx_v_in;
      END IF;
    END IF;
  END PROCESS Delay5_process;


  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_out1 <= '0';
      ELSIF enb_1_128_0 = '1' THEN
        Delay2_out1 <= Delay5_out1;
      END IF;
    END IF;
  END PROCESS Delay2_process;


  channel_estimator_out1_signed <= signed(channel_estimator_out1);

  Delay8_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay8_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay8_out1 <= channel_estimator_out1_signed;
      END IF;
    END IF;
  END PROCESS Delay8_process;


  ch1_i <= std_logic_vector(Delay8_out1);

  channel_estimator_out2_signed <= signed(channel_estimator_out2);

  Delay9_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay9_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay9_out1 <= channel_estimator_out2_signed;
      END IF;
    END IF;
  END PROCESS Delay9_process;


  ch1_q <= std_logic_vector(Delay9_out1);

  channel_estimator_out3_signed <= signed(channel_estimator_out3);

  Delay10_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay10_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay10_out1 <= channel_estimator_out3_signed;
      END IF;
    END IF;
  END PROCESS Delay10_process;


  ch2_i <= std_logic_vector(Delay10_out1);

  channel_estimator_out4_signed <= signed(channel_estimator_out4);

  Delay11_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay11_out1 <= to_signed(16#0000#, 16);
      ELSIF enb = '1' THEN
        Delay11_out1 <= channel_estimator_out4_signed;
      END IF;
    END IF;
  END PROCESS Delay11_process;


  ch2_q <= std_logic_vector(Delay11_out1);

  ce_out_0 <= enb_1_128_1;

  ce_out_1 <= enb_1_1_1;

  rx_v_out <= Delay2_out1;

  probe <= channel_estimator_out11;

  probe_xcorr1 <= channel_estimator_out5;

  probe_xcorr2 <= channel_estimator_out6;

  probe_state <= channel_estimator_out7;

  probe_ch1i <= channel_estimator_out8;

  probe_ch1q <= channel_estimator_out9;

  probe_ch1r <= channel_estimator_out10;

END rtl;

