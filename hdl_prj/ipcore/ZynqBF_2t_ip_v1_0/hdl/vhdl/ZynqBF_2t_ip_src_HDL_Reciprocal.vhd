-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_HDL_Reciprocal.vhd
-- Created: 2019-02-08 23:33:52
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_src_HDL_Reciprocal
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/ch_est/calc_inverse/HDL Reciprocal
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ZynqBF_2t_ip_src_ZynqBF_2tx_fpga_pkg.ALL;

ENTITY ZynqBF_2t_ip_src_HDL_Reciprocal IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        din                               :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
        dout                              :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En14
        );
END ZynqBF_2t_ip_src_HDL_Reciprocal;


ARCHITECTURE rtl OF ZynqBF_2t_ip_src_HDL_Reciprocal IS

  -- Component Declarations
  COMPONENT ZynqBF_2t_ip_src_HDL_Reciprocal_core
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          xin                             :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En30
          ain                             :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En32
          xout                            :   OUT   std_logic_vector(31 DOWNTO 0);  -- ufix32_En30
          aout                            :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32_En32
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : ZynqBF_2t_ip_src_HDL_Reciprocal_core
    USE ENTITY work.ZynqBF_2t_ip_src_HDL_Reciprocal_core(rtl);

  -- Signals
  SIGNAL din_signed                       : signed(31 DOWNTO 0);  -- sfix32_En16
  SIGNAL anorm                            : unsigned(31 DOWNTO 0);  -- ufix32_En32
  SIGNAL dynamicshift                     : unsigned(4 DOWNTO 0);  -- ufix5
  SIGNAL onemoreshift                     : std_logic;  -- ufix1
  SIGNAL changesign                       : std_logic;  -- ufix1
  SIGNAL anorm_p                          : unsigned(31 DOWNTO 0);  -- ufix32_En32
  SIGNAL mstwobit                         : std_logic;  -- ufix1
  SIGNAL inzero                           : std_logic;  -- ufix1
  SIGNAL inzero_reg_reg                   : std_logic_vector(0 TO 9);  -- ufix1 [10]
  SIGNAL inzero_p                         : std_logic;  -- ufix1
  SIGNAL constInf                         : signed(31 DOWNTO 0);  -- sfix32_En14
  SIGNAL changesign_reg_reg               : std_logic_vector(0 TO 10);  -- ufix1 [11]
  SIGNAL changesign_p                     : std_logic;  -- ufix1
  SIGNAL x0                               : unsigned(31 DOWNTO 0);  -- ufix32_En30
  SIGNAL xstage1                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL astage1                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL xstage2                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL astage2                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL xstage3                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL astage3                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL xstage4                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL astage4                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL xstage5                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL astage5                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL xstage5_unsigned                 : unsigned(31 DOWNTO 0);  -- ufix32_En30
  SIGNAL ds_reg_reg                       : vector_of_unsigned5(0 TO 10);  -- ufix5 [11]
  SIGNAL dynamicshift_p                   : unsigned(4 DOWNTO 0);  -- ufix5
  SIGNAL onemoreshift_reg_reg             : std_logic_vector(0 TO 10);  -- ufix1 [11]
  SIGNAL onemoreshift_p                   : std_logic;  -- ufix1
  SIGNAL absdenormout                     : signed(31 DOWNTO 0);  -- sfix32_En14
  SIGNAL uminus_cast                      : signed(32 DOWNTO 0);  -- sfix33_En14
  SIGNAL negdenormout                     : signed(31 DOWNTO 0);  -- sfix32_En14
  SIGNAL denormout                        : signed(31 DOWNTO 0);  -- sfix32_En14
  SIGNAL dout_tmp                         : signed(31 DOWNTO 0);  -- sfix32_En14

BEGIN
  -- Single-rate Reciprocal Implementation using Reciprocal Newton Method

  u_core_stage1_inst : ZynqBF_2t_ip_src_HDL_Reciprocal_core
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              xin => std_logic_vector(x0),  -- ufix32_En30
              ain => std_logic_vector(anorm_p),  -- ufix32_En32
              xout => xstage1,  -- ufix32_En30
              aout => astage1  -- ufix32_En32
              );

  u_core_stage2_inst : ZynqBF_2t_ip_src_HDL_Reciprocal_core
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              xin => xstage1,  -- ufix32_En30
              ain => astage1,  -- ufix32_En32
              xout => xstage2,  -- ufix32_En30
              aout => astage2  -- ufix32_En32
              );

  u_core_stage3_inst : ZynqBF_2t_ip_src_HDL_Reciprocal_core
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              xin => xstage2,  -- ufix32_En30
              ain => astage2,  -- ufix32_En32
              xout => xstage3,  -- ufix32_En30
              aout => astage3  -- ufix32_En32
              );

  u_core_stage4_inst : ZynqBF_2t_ip_src_HDL_Reciprocal_core
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              xin => xstage3,  -- ufix32_En30
              ain => astage3,  -- ufix32_En32
              xout => xstage4,  -- ufix32_En30
              aout => astage4  -- ufix32_En32
              );

  u_core_stage5_inst : ZynqBF_2t_ip_src_HDL_Reciprocal_core
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              xin => xstage4,  -- ufix32_En30
              ain => astage4,  -- ufix32_En32
              xout => xstage5,  -- ufix32_En30
              aout => astage5  -- ufix32_En32
              );

  din_signed <= signed(din);

  -- Input Normalization
  in_norm_output : PROCESS (din_signed)
    VARIABLE out1 : unsigned(4 DOWNTO 0);
    VARIABLE uain : signed(31 DOWNTO 0);
    VARIABLE areintp : unsigned(31 DOWNTO 0);
    VARIABLE c : unsigned(31 DOWNTO 0);
    VARIABLE c_r : std_logic;
    VARIABLE cast : signed(32 DOWNTO 0);
    VARIABLE areintp_0 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_1 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_2 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_3 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_4 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_5 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_6 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_7 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_8 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_9 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_10 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_11 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_12 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_13 : unsigned(1 DOWNTO 0);
    VARIABLE areintp_14 : unsigned(1 DOWNTO 0);
  BEGIN
    IF din_signed(31) = '1' THEN 
      cast :=  - (resize(din_signed, 33));
      uain := cast(31 DOWNTO 0);
      changesign <= '1';
    ELSE 
      uain := din_signed;
      changesign <= '0';
    END IF;
    areintp := unsigned(uain);
    areintp_0 := areintp(31 DOWNTO 30);
    IF (areintp_0(1) OR areintp_0(0)) = '1' THEN 
      out1 := to_unsigned(16#00#, 5);
    ELSE 
      areintp_1 := areintp(29 DOWNTO 28);
      IF (areintp_1(1) OR areintp_1(0)) = '1' THEN 
        out1 := to_unsigned(16#01#, 5);
      ELSE 
        areintp_2 := areintp(27 DOWNTO 26);
        IF (areintp_2(1) OR areintp_2(0)) = '1' THEN 
          out1 := to_unsigned(16#02#, 5);
        ELSE 
          areintp_3 := areintp(25 DOWNTO 24);
          IF (areintp_3(1) OR areintp_3(0)) = '1' THEN 
            out1 := to_unsigned(16#03#, 5);
          ELSE 
            areintp_4 := areintp(23 DOWNTO 22);
            IF (areintp_4(1) OR areintp_4(0)) = '1' THEN 
              out1 := to_unsigned(16#04#, 5);
            ELSE 
              areintp_5 := areintp(21 DOWNTO 20);
              IF (areintp_5(1) OR areintp_5(0)) = '1' THEN 
                out1 := to_unsigned(16#05#, 5);
              ELSE 
                areintp_6 := areintp(19 DOWNTO 18);
                IF (areintp_6(1) OR areintp_6(0)) = '1' THEN 
                  out1 := to_unsigned(16#06#, 5);
                ELSE 
                  areintp_7 := areintp(17 DOWNTO 16);
                  IF (areintp_7(1) OR areintp_7(0)) = '1' THEN 
                    out1 := to_unsigned(16#07#, 5);
                  ELSE 
                    areintp_8 := areintp(15 DOWNTO 14);
                    IF (areintp_8(1) OR areintp_8(0)) = '1' THEN 
                      out1 := to_unsigned(16#08#, 5);
                    ELSE 
                      areintp_9 := areintp(13 DOWNTO 12);
                      IF (areintp_9(1) OR areintp_9(0)) = '1' THEN 
                        out1 := to_unsigned(16#09#, 5);
                      ELSE 
                        areintp_10 := areintp(11 DOWNTO 10);
                        IF (areintp_10(1) OR areintp_10(0)) = '1' THEN 
                          out1 := to_unsigned(16#0A#, 5);
                        ELSE 
                          areintp_11 := areintp(9 DOWNTO 8);
                          IF (areintp_11(1) OR areintp_11(0)) = '1' THEN 
                            out1 := to_unsigned(16#0B#, 5);
                          ELSE 
                            areintp_12 := areintp(7 DOWNTO 6);
                            IF (areintp_12(1) OR areintp_12(0)) = '1' THEN 
                              out1 := to_unsigned(16#0C#, 5);
                            ELSE 
                              areintp_13 := areintp(5 DOWNTO 4);
                              IF (areintp_13(1) OR areintp_13(0)) = '1' THEN 
                                out1 := to_unsigned(16#0D#, 5);
                              ELSE 
                                areintp_14 := areintp(3 DOWNTO 2);
                                IF (areintp_14(1) OR areintp_14(0)) = '1' THEN 
                                  out1 := to_unsigned(16#0E#, 5);
                                ELSE 
                                  out1 := to_unsigned(16#0F#, 5);
                                END IF;
                              END IF;
                            END IF;
                          END IF;
                        END IF;
                      END IF;
                    END IF;
                  END IF;
                END IF;
              END IF;
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
    c := unsigned(uain) sll to_integer(resize(out1 sll 1, 8));
    c_r :=  NOT c(31);
    IF c_r = '1' THEN 
      c := c sll 1;
    END IF;
    anorm <= c;
    dynamicshift <= out1;
    onemoreshift <= c_r;
  END PROCESS in_norm_output;


  anorm_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        anorm_p <= to_unsigned(0, 32);
      ELSIF enb = '1' THEN
        anorm_p <= anorm;
      END IF;
    END IF;
  END PROCESS anorm_reg_process;


  mstwobit <= anorm_p(31);

  
  inzero <= '1' WHEN mstwobit = '0' ELSE
      '0';

  -- Pipeline registers
  inzero_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        inzero_reg_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        inzero_reg_reg(0) <= inzero;
        inzero_reg_reg(1 TO 9) <= inzero_reg_reg(0 TO 8);
      END IF;
    END IF;
  END PROCESS inzero_reg_process;

  inzero_p <= inzero_reg_reg(9);

  constInf <= to_signed(2147483647, 32);

  changesign_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        changesign_reg_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        changesign_reg_reg(0) <= changesign;
        changesign_reg_reg(1 TO 10) <= changesign_reg_reg(0 TO 9);
      END IF;
    END IF;
  END PROCESS changesign_reg_process;

  changesign_p <= changesign_reg_reg(10);

  x0 <= to_unsigned(1073741824, 32);

  xstage5_unsigned <= unsigned(xstage5);

  -- Pipeline registers
  ds_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        ds_reg_reg <= (OTHERS => to_unsigned(16#00#, 5));
      ELSIF enb = '1' THEN
        ds_reg_reg(0) <= dynamicshift;
        ds_reg_reg(1 TO 10) <= ds_reg_reg(0 TO 9);
      END IF;
    END IF;
  END PROCESS ds_reg_process;

  dynamicshift_p <= ds_reg_reg(10);

  onemoreshift_reg_process : PROCESS (clk)
  BEGIN
    IF clk'EVENT AND clk = '1' THEN
      IF reset = '1' THEN
        onemoreshift_reg_reg <= (OTHERS => '0');
      ELSIF enb = '1' THEN
        onemoreshift_reg_reg(0) <= onemoreshift;
        onemoreshift_reg_reg(1 TO 10) <= onemoreshift_reg_reg(0 TO 9);
      END IF;
    END IF;
  END PROCESS onemoreshift_reg_process;

  onemoreshift_p <= onemoreshift_reg_reg(10);

  -- Output Denormalization
  out_denorm_output : PROCESS (dynamicshift_p, onemoreshift_p, xstage5_unsigned)
    VARIABLE xshift : unsigned(31 DOWNTO 0);
    VARIABLE shiftarr : vector_of_unsigned32(0 TO 16);
    VARIABLE c1 : unsigned(5 DOWNTO 0);
    VARIABLE sub_cast : signed(31 DOWNTO 0);
    VARIABLE sub_cast_0 : signed(31 DOWNTO 0);
  BEGIN
    shiftarr(0) := SHIFT_RIGHT(xstage5_unsigned, 31);
    shiftarr(1) := SHIFT_RIGHT(xstage5_unsigned, 29);
    shiftarr(2) := SHIFT_RIGHT(xstage5_unsigned, 27);
    shiftarr(3) := SHIFT_RIGHT(xstage5_unsigned, 25);
    shiftarr(4) := SHIFT_RIGHT(xstage5_unsigned, 23);
    shiftarr(5) := SHIFT_RIGHT(xstage5_unsigned, 21);
    shiftarr(6) := SHIFT_RIGHT(xstage5_unsigned, 19);
    shiftarr(7) := SHIFT_RIGHT(xstage5_unsigned, 17);
    shiftarr(8) := SHIFT_RIGHT(xstage5_unsigned, 15);
    shiftarr(9) := SHIFT_RIGHT(xstage5_unsigned, 13);
    shiftarr(10) := SHIFT_RIGHT(xstage5_unsigned, 11);
    shiftarr(11) := SHIFT_RIGHT(xstage5_unsigned, 9);
    shiftarr(12) := SHIFT_RIGHT(xstage5_unsigned, 7);
    shiftarr(13) := SHIFT_RIGHT(xstage5_unsigned, 5);
    shiftarr(14) := SHIFT_RIGHT(xstage5_unsigned, 3);
    shiftarr(15) := SHIFT_RIGHT(xstage5_unsigned, 1);
    shiftarr(16) := xstage5_unsigned;
    c1 := resize(dynamicshift_p, 6) + to_unsigned(16#01#, 6);
    IF onemoreshift_p = '0' THEN 
      sub_cast_0 := signed(resize(c1, 32));
      xshift := SHIFT_RIGHT(shiftarr(to_integer(sub_cast_0 - 1)), 1);
    ELSE 
      sub_cast := signed(resize(c1, 32));
      xshift := shiftarr(to_integer(sub_cast - 1));
    END IF;
    IF xshift(31) /= '0' THEN 
      absdenormout <= X"7FFFFFFF";
    ELSE 
      absdenormout <= signed(xshift);
    END IF;
  END PROCESS out_denorm_output;


  uminus_cast <=  - (resize(absdenormout, 33));
  negdenormout <= uminus_cast(31 DOWNTO 0);

  -- Change output sign
  
  denormout <= negdenormout WHEN changesign_p = '1' ELSE
      absdenormout;

  -- Zero input logic
  
  dout_tmp <= constInf WHEN inzero_p = '1' ELSE
      denormout;

  dout <= std_logic_vector(dout_tmp);

END rtl;

