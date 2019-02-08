-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\correlation_config.vhd
-- Created: 2019-02-08 13:29:43
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: correlation_config
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/peakdetect_ch1/correlator1/correlation_config
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY correlation_config IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        rst                               :   IN    std_logic;
        vin                               :   IN    std_logic;
        addr                              :   OUT   std_logic_vector(8 DOWNTO 0);  -- ufix9
        shift                             :   OUT   std_logic_vector(5 DOWNTO 0);  -- ufix6
        vout                              :   OUT   std_logic
        );
END correlation_config;


ARCHITECTURE rtl OF correlation_config IS

  -- Signals
  SIGNAL Delay4_out1                      : std_logic;
  SIGNAL Delay1_out1                      : std_logic;
  SIGNAL correlation_count_out1           : unsigned(14 DOWNTO 0);  -- ufix15
  SIGNAL Bit_Slice_out1                   : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Delay2_out1                      : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL shift_count_out1                 : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Delay5_out1                      : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL Delay6_reg                       : std_logic_vector(0 TO 2);  -- ufix1 [3]
  SIGNAL Delay6_out1                      : std_logic;

BEGIN
  Delay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay4_out1 <= '0';
      ELSIF enb = '1' THEN
        Delay4_out1 <= rst;
      END IF;
    END IF;
  END PROCESS Delay4_process;


  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_out1 <= '0';
      ELSIF enb = '1' THEN
        Delay1_out1 <= vin;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  -- Free running, Unsigned Counter
  --  initial value   = 32767
  --  step value      = 1
  correlation_count_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        correlation_count_out1 <= to_unsigned(16#7FFF#, 15);
      ELSIF enb = '1' THEN
        IF Delay4_out1 = '1' THEN 
          correlation_count_out1 <= to_unsigned(16#7FFF#, 15);
        ELSIF Delay1_out1 = '1' THEN 
          correlation_count_out1 <= correlation_count_out1 + to_unsigned(16#0001#, 15);
        END IF;
      END IF;
    END IF;
  END PROCESS correlation_count_process;


  Bit_Slice_out1 <= correlation_count_out1(14 DOWNTO 6);

  Delay2_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay2_out1 <= to_unsigned(16#000#, 9);
      ELSIF enb = '1' THEN
        Delay2_out1 <= Bit_Slice_out1;
      END IF;
    END IF;
  END PROCESS Delay2_process;


  addr <= std_logic_vector(Delay2_out1);

  -- Free running, Unsigned Counter
  --  initial value   = 63
  --  step value      = 1
  shift_count_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        shift_count_out1 <= to_unsigned(16#3F#, 6);
      ELSIF enb = '1' THEN
        IF Delay4_out1 = '1' THEN 
          shift_count_out1 <= to_unsigned(16#3F#, 6);
        ELSIF Delay1_out1 = '1' THEN 
          shift_count_out1 <= shift_count_out1 + to_unsigned(16#01#, 6);
        END IF;
      END IF;
    END IF;
  END PROCESS shift_count_process;


  Delay5_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay5_out1 <= to_unsigned(16#00#, 6);
      ELSIF enb = '1' THEN
        Delay5_out1 <= shift_count_out1;
      END IF;
    END IF;
  END PROCESS Delay5_process;


  shift <= std_logic_vector(Delay5_out1);

  Delay6_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay6_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay6_reg(0) <= Delay1_out1;
        Delay6_reg(1 TO 2) <= Delay6_reg(0 TO 1);
      END IF;
    END IF;
  END PROCESS Delay6_process;

  Delay6_out1 <= Delay6_reg(2);

  vout <= Delay6_out1;

END rtl;

