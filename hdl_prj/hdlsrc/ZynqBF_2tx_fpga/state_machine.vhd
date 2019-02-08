-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\state_machine.vhd
-- Created: 2019-02-08 13:29:44
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: state_machine
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/state_machine
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY state_machine IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        peak_found                        :   IN    std_logic;
        est_done                          :   IN    std_logic;
        cf_done                           :   IN    std_logic;
        pd_en                             :   OUT   std_logic;
        est_en                            :   OUT   std_logic;
        cf_en                             :   OUT   std_logic;
        probe_state                       :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
        );
END state_machine;


ARCHITECTURE rtl OF state_machine IS

  -- Signals
  SIGNAL Delay_reg                        : std_logic_vector(0 TO 2);  -- ufix1 [3]
  SIGNAL Delay_out1                       : std_logic;
  SIGNAL Delay1_reg                       : std_logic_vector(0 TO 2);  -- ufix1 [3]
  SIGNAL Delay1_out1                      : std_logic;
  SIGNAL HDL_Counter_out1                 : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Compare_To_Constant2_out1        : std_logic;
  SIGNAL Logical_Operator1_out1           : std_logic;
  SIGNAL Logical_Operator3_out1           : std_logic;
  SIGNAL Compare_To_Constant_out1         : std_logic;
  SIGNAL Compare_To_Constant1_out1        : std_logic;

BEGIN
  Delay_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay_reg(0) <= peak_found;
        Delay_reg(1 TO 2) <= Delay_reg(0 TO 1);
      END IF;
    END IF;
  END PROCESS Delay_process;

  Delay_out1 <= Delay_reg(2);

  Delay1_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        Delay1_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        Delay1_reg(0) <= est_done;
        Delay1_reg(1 TO 2) <= Delay1_reg(0 TO 1);
      END IF;
    END IF;
  END PROCESS Delay1_process;

  Delay1_out1 <= Delay1_reg(2);

  
  Compare_To_Constant2_out1 <= '1' WHEN HDL_Counter_out1 = to_unsigned(16#02#, 8) ELSE
      '0';

  Logical_Operator1_out1 <= cf_done AND Compare_To_Constant2_out1;

  Logical_Operator3_out1 <= Logical_Operator1_out1 OR (Delay_out1 OR Delay1_out1);

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 2
  HDL_Counter_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        HDL_Counter_out1 <= to_unsigned(16#00#, 8);
      ELSIF enb = '1' THEN
        IF Logical_Operator3_out1 = '1' THEN 
          IF HDL_Counter_out1 >= to_unsigned(16#02#, 8) THEN 
            HDL_Counter_out1 <= to_unsigned(16#00#, 8);
          ELSE 
            HDL_Counter_out1 <= HDL_Counter_out1 + to_unsigned(16#01#, 8);
          END IF;
        END IF;
      END IF;
    END IF;
  END PROCESS HDL_Counter_process;


  
  Compare_To_Constant_out1 <= '1' WHEN HDL_Counter_out1 = to_unsigned(16#00#, 8) ELSE
      '0';

  
  Compare_To_Constant1_out1 <= '1' WHEN HDL_Counter_out1 = to_unsigned(16#01#, 8) ELSE
      '0';

  probe_state <= std_logic_vector(HDL_Counter_out1);

  pd_en <= Compare_To_Constant_out1;

  est_en <= Compare_To_Constant1_out1;

  cf_en <= Compare_To_Constant2_out1;

END rtl;

