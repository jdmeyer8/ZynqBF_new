-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_in_fifo.vhd
-- Created: 2019-02-08 23:33:52
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_src_in_fifo
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/in_fifo
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY UNISIM;
use UNISIM.vcomponents.all;

ENTITY ZynqBF_2t_ip_src_in_fifo IS
  PORT( clk                               :   IN    std_logic;
        clk200                            :   IN    std_logic;
        reset                             :   IN    std_logic;
        reset200                          :   IN    std_logic;
        enb                               :   IN    std_logic;
        enb200                            :   IN    std_logic;
        rxi_in                            :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        rxq_in                            :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        rxv_in                            :   IN    std_logic;
        pd_en                             :   IN    std_logic;
        cf_en                             :   IN    std_logic;
        rxi_out                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        rxq_out                           :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        rxv_out                           :   OUT   std_logic;
        empty                             :   OUT   std_logic
        );
END ZynqBF_2t_ip_src_in_fifo;


ARCHITECTURE rtl OF ZynqBF_2t_ip_src_in_fifo IS

  -- Component Declarations


  -- Signals
  
  signal rst_fifo                         : std_logic;
  
  signal wren                             : std_logic;
  signal rden                             : std_logic;
  signal empty_rxi                        : std_logic;
  signal empty_rxq                        : std_logic;
  signal empty_i                          : std_logic;
  signal empty_n                          : std_logic;
  
  signal pd_en_i                          : std_logic;  -- pd_en after clock-crossing
  signal pd_en_meta_reg                   : std_logic(2 downto 0);
  
  signal rden_dreg                        : std_logic_vector(1 downto 0); -- read enable delay register
  
  

BEGIN

  rst_fifo <= reset200 or cf_en;
  
  u_rx_i_fifo : FIFO_DUALCLOCK_MACRO
  generic map(data_width => 16)
  port map(
    rst => rst_fifo,
    wrclk => clk,
    wren => wren,
    di => rxi_in,
    full => open,
    rdclk => clk200,
    rden => rden,
    do => rx_i_fifo_out,
    empty => empty_rxi,
    almost_empty => open,
    almost_full => open,
    wrerr => open,
    rderr => open,
    wrcount => open,
    rdcount => open
  );
    
  u_rx_q_fifo : FIFO_DUALCLOCK_MACRO
  generic map(data_width => 16)
  port map(
    rst => reset200,
    wrclk => clk,
    wren => wren,
    di => rxi_in,
    full => open,
    rdclk => clk200,
    rden => rden,
    do => rx_i_fifo_out,
    empty => empty_rxi,
    almost_empty => open,
    almost_full => open,
    wrerr => open,
    rderr => open,
    wrcount => open,
    rdcount => open
  );
  
  
  -- Write side signals
  pd_en_metastability_filter : process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pd_en_meta_reg <= "000";
      elsif enb = '1' then
        pd_en_meta_reg <= pd_en_meta_reg(1 downto 0) & pd_en;
      end if;
    end if;
  end process;
  
  pd_en_i <= pd_en_meta_reg(2);
  
  wren <= pd_en_i & rxv_in;
  
  
  -- Read side signals
  empty_i <= empty_rxi & empty_rxq;
  empty_n <= not empty_i;
  
  rden <= pd_en and empty_n;
  empty <= empty_i;
  
  rd_en_delay_process : process(clk200)
  begin
    if clk200'event and clk200 = '1' then
      if reset200 = '1' then
        rd_en_dreg <= "00";
      elsif enb200 = '1' then
        rd_en_dreg <= rd_en_dreg(0) & rd_en;
      end if;
    end if;
  end process;
  
  rxv_out <= rd_en_dreg(1);
  

END rtl;

