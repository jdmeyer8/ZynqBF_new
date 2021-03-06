-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_running_max_block.vhd
-- Created: 2019-02-08 23:33:52
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_src_running_max_block
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/peakdetect_ch2/running_max
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ZynqBF_2t_ip_src_running_max_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        din                               :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        en                                :   IN    std_logic;
        rst                               :   IN    std_logic;
        new_max                           :   OUT   std_logic;
        max_val                           :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En16
        );
END ZynqBF_2t_ip_src_running_max_block;


ARCHITECTURE rtl OF ZynqBF_2t_ip_src_running_max_block IS

  -- Signals
  SIGNAL din_signed                       : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL update_max_p                     : std_logic;
  SIGNAL Delay4_out1                      : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL store_max_out1                   : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL reset_max_out1                   : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL Relational_Operator_relop1       : std_logic;

BEGIN
  din_signed <= signed(din);

  
  store_max_out1 <= Delay4_out1 WHEN update_max_p = '0' ELSE
      din_signed;

  
  reset_max_out1 <= store_max_out1 WHEN rst = '0' ELSE
      to_signed(0, 32);

  Delay4_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay4_out1 <= to_signed(0, 32);
      ELSIF enb = '1' THEN
        Delay4_out1 <= reset_max_out1;
      END IF;
    END IF;
  END PROCESS Delay4_process;


  
  Relational_Operator_relop1 <= '1' WHEN din_signed > Delay4_out1 ELSE
      '0';

  update_max_p <= en AND Relational_Operator_relop1;

  max_val <= std_logic_vector(Delay4_out1);

  new_max <= update_max_p;

END rtl;

