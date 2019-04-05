-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\ZynqBF_2tx_fpga\ZynqBF_2t_ip_src_peakdetect_ch1.vhd
-- Created: 2019-02-08 23:33:51
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ZynqBF_2t_ip_src_peakdetect_ch1
-- Source Path: ZynqBF_2tx_fpga/channel_estimator/peakdetect_ch1
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ZynqBF_2t_ip_src_ZynqBF_2tx_fpga_pkg.ALL;

ENTITY ZynqBF_2t_ip_src_correlators IS
  GENERIC(
        NCORR                             :   integer := 2      -- number of correlators
        );
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        rst                               :   IN    std_logic;
        din_i                             :   IN    std_logic_vector(15 downto 0);  -- sfix16_En15 [2]
        din_q                             :   IN    std_logic_vector(15 downto 0);  -- sfix16_En15 [2]
        vin                               :   IN    std_logic;                      -- rx ram write enable
        pd_en                             :   OUT   std_logic;
        est_en                            :   IN    std_logic;
        index                             :   OUT   std_logic_vector(14 DOWNTO 0);  -- ufix15
        step                              :   OUT   std_logic;
        peak_found                        :   OUT   std_logic;
        est_val                           :   OUT   std_logic;                      -- valid signal for ch_est input
        ch_i                              :   OUT   vector_of_std_logic_vector32(0 to (NCORR-1));
        ch_q                              :   OUT   vector_of_std_logic_vector32(0 to (NCORR-1));
        ch_update                         :   OUT   std_logic;
        probe                             :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En16
        );
END ZynqBF_2t_ip_src_correlators;


ARCHITECTURE rtl OF ZynqBF_2t_ip_src_correlators IS

  -- Component Declarations
  COMPONENT ZynqBF_2t_ip_src_running_max
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          din                             :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En16
          en                              :   IN    std_logic;
          rst                             :   IN    std_logic;
          new_max                         :   OUT   std_logic;
          max_val                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En16
          );
  END COMPONENT;

  component ZynqBF_2t_ip_src_rx_bram 
  port( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        din_i                             :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        din_q                             :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En15
        we                                :   IN    std_logic;
        wr_addr                           :   IN    std_logic_vector(14 DOWNTO 0);  -- ufix15
        rd_addr                           :   IN    std_logic_vector(14 DOWNTO 0);  -- ufix15
        shift                             :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix15
        dout_i_single                     :   OUT   std_logic_vector(15 downto 0);
        dout_q_single                     :   OUT   std_logic_vector(15 downto 0);
        dout_i                            :   OUT   vector_of_std_logic_vector16(0 TO 63);  -- rx i data for the correlators
        dout_q                            :   OUT   vector_of_std_logic_vector16(0 TO 63)   -- rx q data for the correlators
        );
  END COMPONENT;
  
  component ZynqBF_2t_ip_src_goldSeq
  generic (N                              :   integer := 2);
  port( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        -- addr                              :   IN    std_logic_vector(5 DOWNTO 0);
        -- addr_lsb                          :   IN    std_logic_vector(5 downto 0);
        addr                              :   IN    vector_of_std_logic_vector6(0 to (N-1));
        addr_lsb                          :   IN    vector_of_std_logic_vector6(0 to (N-1));
        gs_out_single                     :   OUT   vector_of_std_logic_vector16(0 to (N-1));
        gs_out                            :   OUT   vector_of_std_logic_vector16(0 to (N*64 - 1))
        );
  end component;
  
  component ZynqBF_2t_ip_src_shift_rx
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        u                                 :   IN    vector_of_std_logic_vector16(0 TO 63);  -- sfix16_En15 [64]
        shift                             :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
        y                                 :   OUT   vector_of_std_logic_vector16(0 TO 63)  -- sfix16_En15 [64]
        );
  END component;
  
  component ZynqBF_2t_ip_src_rx_gs_mult
  generic( N                              :   integer := 2);
  port( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        start                             :   IN    std_logic;
        en                                :   IN    std_logic;  -- enable for MACC
        rxi                               :   IN    vector_of_std_logic_vector16(0 TO 63);  -- rx i data for the correlators
        rxq                               :   IN    vector_of_std_logic_vector16(0 TO 63);  -- rx q data for the correlators
        gsi                               :   IN    vector_of_std_logic_vector16(0 TO (64*N-1));  -- gs i data for the correlators
        gsq                               :   IN    vector_of_std_logic_vector16(0 TO (64*N-1));  -- gs q data for the correlators
        done                              :   OUT   std_logic;
        dout                              :   OUT   vector_of_std_logic_vector32(0 TO (N-1))
        );
  end component;
  
  component ZynqBF_2t_ip_src_ch_est2
  port( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        rxi                               :   IN    std_logic_vector(15 downto 0);  -- sfix16_En15
        rxq                               :   IN    std_logic_vector(15 downto 0);  -- sfix16_En15
        gsi                               :   IN    std_logic_vector(15 downto 0);  -- sfix16_En15
        gsq                               :   IN    std_logic_vector(15 downto 0);  -- sfix16_En15
        start                             :   IN    std_logic;
        en                                :   IN    std_logic;
        base_addr                         :   IN    std_logic_vector(14 downto 0);
        rx_addr                           :   IN    std_logic_vector(14 downto 0);
        gs_addr_msb                       :   OUT   std_logic_vector(5 downto 0);
        gs_addr_lsb                       :   OUT   std_logic_vector(5 downto 0);
        ch_i                              :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix16_En15
        ch_q                              :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix16_En15
        done                              :   OUT   std_logic
        );
  end component;
        

  -- Component Configuration Statements
  FOR ALL : ZynqBF_2t_ip_src_running_max
    USE ENTITY work.ZynqBF_2t_ip_src_running_max(rtl);

  --FOR ALL : ZynqBF_2t_ip_src_store_index
  --  USE ENTITY work.ZynqBF_2t_ip_src_store_index(rtl);
    
  FOR ALL : ZynqBF_2t_ip_src_rx_bram
    USE ENTITY work.ZynqBF_2t_ip_src_rx_bram(rtl);
    
  FOR ALL : ZynqBF_2t_ip_src_goldSeq
    USE ENTITY work.ZynqBF_2t_ip_src_goldSeq(rtl);  
    
  FOR ALL : ZynqBF_2t_ip_src_shift_rx
    USE ENTITY work.ZynqBF_2t_ip_src_shift_rx(rtl);
    
  FOR ALL : ZynqBF_2t_ip_src_rx_gs_mult
    USE ENTITY work.ZynqBF_2t_ip_src_rx_gs_mult(rtl);
 
  FOR ALL : ZynqBF_2t_ip_src_ch_est2
    USE ENTITY work.ZynqBF_2t_ip_src_ch_est2(rtl);

  -- Signals  
  signal rxi                              : vector_of_std_logic_vector16(0 to 63);
  signal rxq                              : vector_of_std_logic_vector16(0 to 63);
  signal gsdata                           : vector_of_std_logic_vector16(0 to (64*NCORR - 1));
  signal gsi                              : vector_of_std_logic_vector16(0 to (64*NCORR - 1));
  signal gsq                              : vector_of_std_logic_vector16(0 to (64*NCORR - 1));
  signal rxi_shifted                      : vector_of_std_logic_vector16(0 to 63);
  signal rxq_shifted                      : vector_of_std_logic_vector16(0 to 63);
  
  signal rx_ram_we                        : std_logic;
  signal rxi_single                       : std_logic_vector(15 downto 0);
  signal rxq_single                       : std_logic_vector(15 downto 0);
  signal gsi_single                       : vector_of_std_logic_vector16(0 to (NCORR-1));
  signal gsq_single                       : vector_of_std_logic_vector16(0 to (NCORR-1));
  signal gsdata_single                    : vector_of_std_logic_vector16(0 to (NCORR-1));
  
  signal rx_sel                           : integer range 0 to 63;
  
  signal vin_dreg                         : std_logic_vector(2 downto 0);   -- 3 stage delay register for vin signal
  signal inc_rx_ram_wraddr                : std_logic;                      -- flag to increment the rx ram wr addr
  
  signal corr_start                       : std_logic;
  signal corr_start_dreg                  : std_logic_vector(2 downto 0);   -- 3 stage delay register for corr start signal
  signal corr_start_d3                    : std_logic;
  signal corr_en                          : std_logic;
  signal corr_en_d3                       : std_logic;
  signal corr_en_dreg                     : std_logic_vector(2 downto 0);   -- 3 stage delay register for corr en signal
  signal rx_ram_re                        : std_logic;
  signal rx_ram_wraddr                    : std_logic_vector(14 downto 0);
  signal rx_ram_rdaddr                    : std_logic_vector(14 downto 0);
  signal rx_ram_shift                     : std_logic_vector(5 downto 0);
  signal gs_ram_rdaddr_msb                : vector_of_std_logic_vector6(0 to (NCORR-1));
  signal gs_ram_rdaddr_lsb                : vector_of_std_logic_vector6(0 to (NCORR-1));
  signal rx_in_addr                       : unsigned(14 downto 0);
  signal shift_cnt                        : unsigned(5 downto 0);
  
  signal pd_rxaddr                        : std_logic_vector(14 downto 0);
  signal pd_gsaddr                        : std_logic_vector(5 downto 0);
  
  signal pd_en_reg                        : unsigned(0 to (NCORR-1));
  
  signal corr_shift                       : unsigned(5 downto 0);           -- latch value of shift_cnt at the start of the correlation
  signal corr_cnt                         : unsigned(11 downto 0);          -- correlation counter (and address for gs ram, address offset for rx ram)
  signal corr_base                        : unsigned(14 downto 0);          -- correlation base address for rx ram

  signal corr_done                        : std_logic;
  signal corr_dout                        : vector_of_std_logic_vector32(0 to (NCORR-1));
  
  -- peak tracking fsm/
  -- signal cs_ptrack                        : std_logic_vector(2 downto 0);
  signal cs_ptrack                        : vector_of_std_logic_vector3(0 to (NCORR-1));
  constant s_wait                         : std_logic_vector(2 downto 0) := "001";
  constant s_track                        : std_logic_vector(2 downto 0) := "010";
  constant s_finish                       : std_logic_vector(2 downto 0) := "100";
  
  signal ptrack_ind                       : integer range 0 to (NCORR-1);   -- index of which correlator has a peak detected
  signal ptrack_addr_in                   : unsigned(14 downto 0);
  signal ptrack_start                     : unsigned(0 to (NCORR-1));
  signal ptrack_en                        : unsigned(0 to (NCORR-1));
  signal ptrack_cnt                       : vector_of_unsigned8(0 to (NCORR-1));
  constant PTRACK_CNT_END                 : unsigned(7 downto 0) := x"40";  -- look for peak across 64 samples
  
  signal ram_index                        : std_logic_vector(14 downto 0);
  signal update_est_index                 : std_logic_vector(0 to (NCORR-1));
  
  signal corr_threshold                   : vector_of_std_logic_vector32(0 to (NCORR-1));
  constant corr_thresh_const              : vector_of_std_logic_vector32(0 to (NCORR-1)) := (others => x"00250000");
  
  signal cs_main                          : vector_of_std_logic_vector8(0 to (NCORR-1));    -- main FSM
  constant s_peakdetect                   : std_logic_vector(7 downto 0) := "00000001";
  constant s_wait2                        : std_logic_vector(7 downto 0) := "00000010";
  constant s_channelest                   : std_logic_vector(7 downto 0) := "00000100";
  constant s_wait3                        : std_logic_vector(7 downto 0) := "00001000";
  constant s_reset                        : std_logic_vector(7 downto 0) := "00010000";
  
  signal ch_est_start                     : std_logic;
  signal ch_est_start_reg                 : unsigned(0 to (NCORR-1));
  signal ch_est_en                        : std_logic;
  signal ch_est_en_reg                    : unsigned(0 to (NCORR-1));
  signal ch_est_done                      : unsigned(0 to (NCORR-1));
  signal ch_est_rxaddr                    : unsigned(14 downto 0);
  signal ch_est_gsaddr_msb                : vector_of_std_logic_vector6(0 to (NCORR-1));
  signal ch_est_gsaddr_lsb                : vector_of_std_logic_vector6(0 to (NCORR-1));
  
  signal ch_est_index_start               : vector_of_std_logic_vector15(0 to (NCORR-1));
  signal ch_est_base_addr                 : std_logic_vector(14 downto 0);
  signal ch_est_base_locked               : std_logic;
  
  
  signal ch1_corr_probe                   : std_logic_vector(31 downto 0);
  signal ch2_corr_probe                   : std_logic_vector(31 downto 0);
  signal ch3_corr_probe                   : std_logic_vector(31 downto 0);
  signal ch4_corr_probe                   : std_logic_vector(31 downto 0);
  signal ch5_corr_probe                   : std_logic_vector(31 downto 0);
  
  attribute mark_debug                    : string;
  attribute mark_debug of ch1_corr_probe  : signal is "true";
  attribute mark_debug of ch2_corr_probe  : signal is "true";
  attribute mark_debug of ch3_corr_probe  : signal is "true";
  attribute mark_debug of ch4_corr_probe  : signal is "true";
  attribute mark_debug of ch5_corr_probe  : signal is "true";
  
BEGIN

  --gsi <= gsdata;
  --gsq <= gsdata;
  --gsi_single <= gsdata_single;
  --gsq_single <= gsdata_single;
  corr_threshold <= corr_thresh_const;
  ram_index <= std_logic_vector(unsigned(rx_ram_wraddr) - to_unsigned(16#1000#, ram_index'length));
  --rx_sel <= to_integer(unsigned(rx_ram_rdaddr(5 downto 0)));
  --rxi_single <= rxi(rx_sel);
  --rxq_single <= rxq(rx_sel);
  
  corr_start <= vin_dreg(2) when ch_est_en_reg = to_unsigned(16#0#, NCORR) else '0';
  inc_rx_ram_wraddr <= vin_dreg(2);
  
--  rx_ram_rdaddr <= std_logic_vector(corr_cnt + corr_base);
--  gs_ram_rdaddr <= std_logic_vector(corr_cnt(11 downto 6));
  pd_rxaddr <= std_logic_vector(corr_cnt + corr_base);
  pd_gsaddr <= std_logic_vector(corr_cnt(11 downto 6));
  
  pd_en <= '1' when pd_en_reg > to_unsigned(16#0#, NCORR) else '0';
  
  rx_ram_we <= vin when ch_est_en_reg = to_unsigned(16#0#, NCORR) else '0';
  rx_ram_rdaddr <= std_logic_vector(ch_est_rxaddr) when ch_est_en = '1' else pd_rxaddr;
  rx_ram_shift <= std_logic_vector(shift_cnt) when ch_est_en = '1' else std_logic_vector(corr_shift);
  gs_ram_rdaddr_msb <= ch_est_gsaddr_msb when ch_est_en = '1' else (others => pd_gsaddr);
  gs_ram_rdaddr_lsb <= ch_est_gsaddr_lsb when ch_est_en = '1' else (others => (others => '0'));
  
  ch_est_start <= '1' when ch_est_start_reg > to_unsigned(16#0#, NCORR) else '0';
  ch_est_en <= '1' when ch_est_en_reg > to_unsigned(16#0#, NCORR) else '0';
  
  ch_update <= '1' when cs_main(0) = s_reset else '0';

  u_rx_bram : ZynqBF_2t_ip_src_rx_bram
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              din_i => din_i,
              din_q => din_q,
              we => vin,
              wr_addr => rx_ram_wraddr,
              rd_addr => rx_ram_rdaddr,
              shift => rx_ram_shift,
              dout_i_single => rxi_single,
              dout_q_single => rxq_single,
              dout_i => rxi,
              dout_q => rxq
              );
              
  u_gs : ZynqBF_2t_ip_src_goldSeq
    GENERIC MAP (N => NCORR)
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              addr => gs_ram_rdaddr_msb,
              addr_lsb => gs_ram_rdaddr_lsb,
              gs_out_single => gsdata_single,
              gs_out => gsdata
              );
              
  u_shift_rxi : ZynqBF_2t_ip_src_shift_rx
    PORT MAP( clk => clk,
              reset => reset,
              u => rxi,
              shift => std_logic_vector(corr_shift),
              y => rxi_shifted
              );
  
  u_shift_rxq : ZynqBF_2t_ip_src_shift_rx
    PORT MAP( clk => clk,
              reset => reset,
              u => rxq,
              shift => std_logic_vector(corr_shift),
              y => rxq_shifted
              );
  
  u_rx_gs_mult : ZynqBF_2t_ip_src_rx_gs_mult
    GENERIC MAP ( N => NCORR)
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              start => corr_start_d3,
              en => corr_en_d3,
              rxi => rxi_shifted,
              rxq => rxq_shifted,
              gsi => gsi,
              gsq => gsq,
              done => corr_done,
              dout => corr_dout
              );

  gen_running_max: for i in 0 to (NCORR-1) generate
    u_running_max_i : ZynqBF_2t_ip_src_running_max
      PORT MAP( clk => clk,
                reset => reset,
                enb => enb,
                din => corr_dout(i),  -- sfix32_En16
                en => cs_ptrack(i)(1),
                rst => cs_ptrack(i)(2),
                new_max => update_est_index(i),
                max_val => open  -- sfix32_En16
                );
  end generate;
  
  gen_ch_est: for i in 0 to (NCORR-1) generate
    u_ch_est_i : ZynqBF_2t_ip_src_ch_est2
      PORT MAP( clk => clk,
                reset => reset,
                enb => enb,
                rxi => rxi_single,
                rxq => rxq_single,
                gsi => gsi_single(i),
                gsq => gsq_single(i),
                start => ch_est_start,
                en => ch_est_en,
                base_addr => ch_est_index_start(i),
                rx_addr => std_logic_vector(ch_est_rxaddr),
                gs_addr_msb => ch_est_gsaddr_msb(i),
                gs_addr_lsb => ch_est_gsaddr_lsb(i),
                ch_i => ch_i(i),
                ch_q => ch_q(i),
                done => ch_est_done(i)
                );
  end generate;
                  
                  
  register_gs_data : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            gsi <= (others => (others => '0'));
            gsq <= (others => (others => '0'));
            gsi_single <= (others => (others => '0'));
            gsq_single <= (others => (others => '0'));
        elsif enb = '1' then
            gsi <= gsdata;
            gsq <= gsdata;
            gsi_single <= gsdata_single;
            gsq_single <= gsdata_single;
        end if;
    end if;
  end process;

  vin_delay_process : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            vin_dreg <= "000";
        elsif enb = '1' then
            vin_dreg <= vin_dreg(1 downto 0) & vin;
        end if;
    end if;
  end process;
  
  addr_in_counters_process : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' or ch_est_start = '1' then
            rx_in_addr <= (others => '0');
            shift_cnt <= (others => '0');
        elsif enb = '1' and inc_rx_ram_wraddr = '1' then
            if rx_in_addr = "111000000000000" then
                rx_in_addr <= (others => '0');
            else
                rx_in_addr <= rx_in_addr + 1;
            end if;
            shift_cnt <= shift_cnt + 1;
        end if;
    end if;
  end process;
  
  rx_ram_wraddr <= std_logic_vector(rx_in_addr + "000111111111111");
  
  
  -- CORRELATOR CONTROLS
  correlation_enable_process : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            corr_en <= '0';
        elsif enb = '1' then
            if corr_done = '1' then
                corr_en <= '0';
            elsif corr_start = '1' then
                corr_en <= '1';
            end if;
        end if;
    end if;
  end process;
  
  corr_start_delay : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            corr_start_dreg <= (others => '0');
        elsif enb = '1' then
            corr_start_dreg <= corr_start_dreg(corr_start_dreg'high-1 downto 0) & corr_start;
        end if;
    end if;
  end process;
  
  corr_start_d3 <= corr_start_dreg(2);
  
  corr_en_delay_process : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            corr_en_dreg <= (others => '0');
        elsif enb = '1' then
            corr_en_dreg <= corr_en_dreg(corr_en_dreg'high-1 downto 0) & corr_en;
        end if;
    end if;
  end process;
  
  corr_en_d3 <= corr_en_dreg(2);
  
  correlation_control_process : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            corr_shift <= (others => '0');
            corr_cnt <= (others => '0');
            corr_base <= (others => '0');
        elsif enb = '1' then
            if corr_start = '1' then
                corr_shift <= shift_cnt;
                corr_cnt <= (others => '0');
                corr_base <= rx_in_addr;
            elsif corr_en = '1' then
                corr_shift <= corr_shift;
                corr_cnt <= corr_cnt + 64;  -- increment by the number of parallel DSPs for each correlator iteration
                corr_base <= corr_base;
            else
                corr_shift <= corr_shift;
                corr_cnt <= (others => '0');
                corr_base <= corr_base;
            end if;
        end if;
    end if;
  end process;
  
  peak_detect_enable : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            pd_en_reg <= (others => '0');
        elsif enb = '1' then
            for i in 0 to (NCORR-1) loop
                if cs_main(i) = s_peakdetect then
                    pd_en_reg(i) <= '1';
                else
                    pd_en_reg(i) <= '0';
                end if;
            end loop;
        end if;
    end if;
  end process;
  
  
  -- PEAK TRACKING CONTROLS
  detect_threshold_crossing : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            ptrack_start <= (others => '0');
            ptrack_ind <= 0;
        elsif enb = '1' then 
            for i in 0 to (NCORR-1) loop
                if cs_ptrack(i) = s_wait then
                    if signed(corr_dout(i)) >= signed(corr_threshold(i)) then
                        ptrack_start(i) <= '1';
                    else
                        ptrack_start(i) <= '0';
                    end if;
                else
                    ptrack_start(i) <= '0';
                end if;
            end loop;
        end if;
    end if;
  end process;
  
  ptrack_enable_register : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            ptrack_en <= (others => '0');
        elsif enb = '1' then
            for i in 0 to (NCORR-1) loop
                if cs_ptrack(i) = s_track then
                    ptrack_en(i) <= '1';
                else
                    ptrack_en(i) <= '0';
                end if;
            end loop;
        end if;
    end if;
  end process;
  
  peak_tracking_fsm : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            for i in 0 to (NCORR-1) loop
                cs_ptrack(i) <= s_wait;
            end loop;
        elsif enb = '1' then
            for i in 0 to (NCORR-1) loop
                case cs_ptrack(i) is
                    when s_wait =>
                        if ptrack_start(i) = '1' then
                            cs_ptrack(i) <= s_track;
                        else
                            cs_ptrack(i) <= s_wait;
                        end if;
                    when s_track =>
                        if ptrack_cnt(i) >= PTRACK_CNT_END and corr_done = '1' then
                            cs_ptrack(i) <= s_finish;
                        else
                            cs_ptrack(i) <= s_track;
                        end if;
                    when s_finish =>
                        cs_ptrack(i) <= s_wait;
                    when others =>
                        cs_ptrack(i) <= s_wait;
                end case;
            end loop;
        end if;
    end if;
  end process;
  
  peak_track_counter : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            for i in 0 to (NCORR-1) loop
                ptrack_cnt(i) <= x"00";
            end loop;
        elsif enb = '1' then 
            for i in 0 to (NCORR-1) loop 
                if cs_ptrack(i) = s_track then
                    if corr_done = '1' then
                        ptrack_cnt(i) <= ptrack_cnt(i) + 1;
                    end if;
                else
                    ptrack_cnt(i) <= x"00";
                end if;
            end loop;
        end if;
    end if;
  end process;
  
  index_of_max_corr : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            ch_est_index_start <= (others => (others => '0'));
        elsif enb = '1' then
            for i in 0 to (NCORR-1) loop
                if update_est_index(i) = '1' then
                    ch_est_index_start(i) <= ram_index;
                end if;
            end loop;
        end if;
    end if;
  end process;
  
  first_address_ch_est : process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
          ch_est_base_addr <= (others => '0');
          ch_est_base_locked <= '0';
      elsif enb = '1' then
          for i in 0 to (NCORR-1) loop
              if cs_main(i) = s_wait2 then
                  if ch_est_base_locked = '0' then
                      ch_est_base_addr <= ch_est_index_start(i);
                      ch_est_base_locked <= '1';
                  end if;
              elsif cs_main(i) = s_reset then
                  ch_est_base_addr <= (others => '0');
                  ch_est_base_locked <= '0';
              end if;
            end loop;
        end if;
    end if;
  end process;
  
  -- MAIN FSM
  main_fsm : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            cs_main <= (others => s_peakdetect);
        elsif enb = '1' then
            for i in 0 to (NCORR-1) loop
                case cs_main(i) is
                    when s_peakdetect =>
                        if cs_ptrack(i) = s_finish then
                            cs_main(i) <= s_wait2;
                        else
                            cs_main(i) <= s_peakdetect;
                        end if;
                    when s_wait2 =>
                            if ptrack_en > to_unsigned(16#0#, NCORR) then
                                cs_main(i) <= s_wait2;
                            else
                                cs_main(i) <= s_channelest;
                            end if;
                    when s_channelest =>
                        if ch_est_done(i) = '1' then
                            cs_main(i) <= s_wait3;
                        else
                            cs_main(i) <= s_channelest;
                        end if;
                    when s_wait3 =>
                        if ch_est_en_reg > to_unsigned(16#0#, NCORR) then
                            cs_main(i) <= s_wait3;
                        else
                            cs_main(i) <= s_reset;
                        end if;
                    when s_reset =>
                        cs_main(i) <= s_peakdetect;
                    when others =>
                        cs_main(i) <= s_peakdetect;
                end case;
            end loop;
        end if;
    end if;
  end process;
  
  
  -- CHANNEL ESTIMATOR CONTROLS
  channel_estimate_start : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            ch_est_start_reg <= (others => '0');
        elsif enb = '1' then
            for i in 0 to (NCORR-1) loop
                if cs_main(i) = s_wait2 and ptrack_en = to_unsigned(16#0#, NCORR) then
                    ch_est_start_reg(i) <= '1';
                else
                    ch_est_start_reg(i) <= '0';
                end if;
            end loop;
        end if;
    end if;
  end process;
  
  channel_estimate_enable : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            ch_est_en_reg <= (others => '0');
        elsif enb = '1' then
            for i in 0 to (NCORR-1) loop
                if cs_main(i) = s_channelest then
                    ch_est_en_reg(i) <= '1';
                else
                    ch_est_en_reg(i) <= '0';
                end if;
            end loop;
        end if;
    end if;
  end process;
  
  channel_estimate_rxaddr_process : process(clk)
  begin
    if clk'event and clk = '1' then
        if reset = '1' then
            ch_est_rxaddr <= (others => '0');
        elsif enb = '1' then
            if ch_est_en = '1' then
                ch_est_rxaddr <= ch_est_rxaddr + 1;
            elsif ch_est_start = '1' then
                ch_est_rxaddr <= unsigned(ch_est_base_addr);
            elsif ch_est_done > to_unsigned(16#0#, NCORR) then
                ch_est_rxaddr <= (others => '0');
            end if;
        end if;
    end if;
  end process;
  
  
  probes_process : process(clk)
    begin
      if clk'event and clk = '1' then
          if clk = '1' then
              ch1_corr_probe <= (others => '0');
              ch2_corr_probe <= (others => '0');
              ch3_corr_probe <= (others => '0');
              ch4_corr_probe <= (others => '0');
              ch5_corr_probe <= (others => '0');
          else
              ch1_corr_probe <= std_logic_vector(abs(signed(corr_dout(0))));
              ch2_corr_probe <= std_logic_vector(abs(signed(corr_dout(1))));
              ch3_corr_probe <= std_logic_vector(abs(signed(corr_dout(2))));
              ch4_corr_probe <= std_logic_vector(abs(signed(corr_dout(3))));
              ch5_corr_probe <= std_logic_vector(abs(signed(corr_dout(4))));
          end if;
      end if;
    end process;

END rtl;

