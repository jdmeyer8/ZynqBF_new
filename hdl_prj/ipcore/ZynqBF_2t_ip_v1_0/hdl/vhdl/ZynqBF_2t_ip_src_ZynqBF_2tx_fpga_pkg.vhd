-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_ZynqBF_2tx_fpga_pkg.vhd
-- Created: 2019-02-08 23:33:52
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE ZynqBF_2t_ip_src_ZynqBF_2tx_fpga_pkg IS
  TYPE vector_of_std_logic_vector3 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(2 DOWNTO 0);
  TYPE vector_of_std_logic_vector4 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(3 DOWNTO 0);
  TYPE vector_of_std_logic_vector8 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(7 DOWNTO 0);
  TYPE vector_of_std_logic_vector15 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(14 DOWNTO 0);
  TYPE vector_of_std_logic_vector16 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(15 DOWNTO 0);
  TYPE vector_of_std_logic_vector32 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(31 DOWNTO 0);
  TYPE vector_of_std_logic_vector64 IS ARRAY (NATURAL RANGE <>) OF std_logic_vector(63 DOWNTO 0);
  TYPE vector_of_signed16 IS ARRAY (NATURAL RANGE <>) OF signed(15 DOWNTO 0);
  TYPE vector_of_signed32 IS ARRAY (NATURAL RANGE <>) OF signed(31 DOWNTO 0);
  TYPE vector_of_signed48 IS ARRAY (NATURAL RANGE <>) OF signed(47 DOWNTO 0);
  TYPE vector_of_unsigned5 IS ARRAY (NATURAL RANGE <>) OF unsigned(4 DOWNTO 0);
  TYPE vector_of_unsigned6 IS ARRAY (NATURAL RANGE <>) OF unsigned(5 DOWNTO 0);
  TYPE vector_of_unsigned8 IS ARRAY (NATURAL RANGE <>) OF unsigned(7 DOWNTO 0);
  TYPE vector_of_unsigned9 IS ARRAY (NATURAL RANGE <>) OF unsigned(8 DOWNTO 0);
  TYPE vector_of_unsigned12 IS ARRAY (NATURAL RANGE <>) OF unsigned(11 DOWNTO 0);
  TYPE vector_of_unsigned15 IS ARRAY (NATURAL RANGE <>) OF unsigned(14 DOWNTO 0);
  TYPE vector_of_unsigned32 IS ARRAY (NATURAL RANGE <>) OF unsigned(31 DOWNTO 0);
END ZynqBF_2t_ip_src_ZynqBF_2tx_fpga_pkg;

