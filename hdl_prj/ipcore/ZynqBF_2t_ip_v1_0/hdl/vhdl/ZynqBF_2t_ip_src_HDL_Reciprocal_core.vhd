-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_HDL_Reciprocal_core.vhd
-- Created: 2019-02-08 23:33:52
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_src_HDL_Reciprocal_core
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/ch_est/calc_inverse/HDL Reciprocal/HDL Reciprocal_core
-- Hierarchy Level: 5
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ZynqBF_2t_ip_src_ZynqBF_2tx_fpga_pkg.ALL;

ENTITY ZynqBF_2t_ip_src_HDL_Reciprocal_core IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        xin                               :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En30
        ain                               :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En32
        xout                              :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32_En30
        aout                              :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32_En32
        );
END ZynqBF_2t_ip_src_HDL_Reciprocal_core;


ARCHITECTURE rtl OF ZynqBF_2t_ip_src_HDL_Reciprocal_core IS

  -- Signals
  SIGNAL const2                           : unsigned(31 DOWNTO 0);  -- ufix32_En30
  SIGNAL ain_unsigned                     : unsigned(31 DOWNTO 0);  -- ufix32_En32
  SIGNAL xin_unsigned                     : unsigned(31 DOWNTO 0);  -- ufix32_En30
  SIGNAL mul1_mul_temp                    : unsigned(63 DOWNTO 0);  -- ufix64_En62
  SIGNAL mulout1                          : unsigned(31 DOWNTO 0);  -- ufix32_En30
  SIGNAL mulout1delay                     : unsigned(31 DOWNTO 0);  -- ufix32_En30
  SIGNAL subtractor_sub_temp              : unsigned(32 DOWNTO 0);  -- ufix33_En30
  SIGNAL subout                           : unsigned(31 DOWNTO 0);  -- ufix32_En30
  SIGNAL xindelay1                        : unsigned(31 DOWNTO 0);  -- ufix32_En30
  SIGNAL mul2_mul_temp                    : unsigned(63 DOWNTO 0);  -- ufix64_En60
  SIGNAL mulout2                          : unsigned(31 DOWNTO 0);  -- ufix32_En30
  SIGNAL xout_tmp                         : unsigned(31 DOWNTO 0);  -- ufix32_En30
  SIGNAL aout_reg_reg                     : vector_of_unsigned32(0 TO 1);  -- ufix32 [2]
  SIGNAL aout_tmp                         : unsigned(31 DOWNTO 0);  -- ufix32_En32

BEGIN
  -- Iteration Core of the Recip Implementation using Newton Method

  const2 <= unsigned'(X"80000000");

  ain_unsigned <= unsigned(ain);

  xin_unsigned <= unsigned(xin);

  mul1_mul_temp <= ain_unsigned * xin_unsigned;
  mulout1 <= mul1_mul_temp(63 DOWNTO 32);

  xinterm1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        mulout1delay <= to_unsigned(0, 32);
      ELSIF enb = '1' THEN
        mulout1delay <= mulout1;
      END IF;
    END IF;
  END PROCESS xinterm1_reg_process;


  subtractor_sub_temp <= (resize(const2, 33)) - (resize(mulout1delay, 33));
  
  subout <= X"FFFFFFFF" WHEN subtractor_sub_temp(32) /= '0' ELSE
      subtractor_sub_temp(31 DOWNTO 0);

  xindelay1_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        xindelay1 <= to_unsigned(0, 32);
      ELSIF enb = '1' THEN
        xindelay1 <= xin_unsigned;
      END IF;
    END IF;
  END PROCESS xindelay1_reg_process;


  mul2_mul_temp <= subout * xindelay1;
  
  mulout2 <= X"FFFFFFFF" WHEN mul2_mul_temp(63 DOWNTO 62) /= "00" ELSE
      mul2_mul_temp(61 DOWNTO 30);

  xout_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        xout_tmp <= to_unsigned(0, 32);
      ELSIF enb = '1' THEN
        xout_tmp <= mulout2;
      END IF;
    END IF;
  END PROCESS xout_reg_process;


  xout <= std_logic_vector(xout_tmp);

  aout_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        aout_reg_reg <= (OTHERS => to_unsigned(0, 32));
      ELSIF enb = '1' THEN
        aout_reg_reg(0) <= ain_unsigned;
        aout_reg_reg(1) <= aout_reg_reg(0);
      END IF;
    END IF;
  END PROCESS aout_reg_process;

  aout_tmp <= aout_reg_reg(1);

  aout <= std_logic_vector(aout_tmp);

END rtl;
