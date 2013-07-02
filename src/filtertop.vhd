/* Moving Average Filter
file: maftop.vhd
author: Frank Andre Moreno vera
e-mail: frank.moreno@ieee.com
*/
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.filterpack.all;

entity filtertop is
  generic(M: natural := 11);
  port(
    clk,clr:  in  std_logic;
    y:        out number;
    ad_sdat:  in  std_logic;
    ad_saddr: out std_logic;
    ad_cs_n:  out std_logic
  );
end entity;

architecture behavioral of filtertop is
  constant ad_addr:  std_logic_vector(2 downto 0) := "000";
  signal sample_clk: std_logic;
  signal ad_data:    std_logic_vector(11 downto 0);
  signal sclK:       std_logic;
  signal x:          number;
  signal h:          numbers(0 to M);
begin

Frec_divider: entity work.frecuency_divider
  port map(
    rst     => clr,
    clk_in  => clk,
    clk_out => SCLK
  );

ADC_reading: entity work.adc128s022
  port map(
    en_n       => not clr,
    ad_sclk    => sclk,
    ad_addr    => ad_addr,
    ad_saddr   => ad_saddr,
    ad_sdat    => ad_sdat,
    ad_data    => ad_data,
    ad_cs_n    => ad_cs_n,
    sample_clk => sample_clk
  );

Asign_x: x <= slv_to_num(ad_data);
Filter:  MAF_filter(x,h,y);

delays: entity work.delayer
  generic map(M => M)
  port map( 
    clk    => sample_clk,
    clr    => clr,
    input  => h(0),
    output => h(1 to h'high)
  );

/*
DAC_writer: entity work.dac121s101
  port map(
    go    =>: in STD_LOGIC;
    da_a  =>: in STD_LOGIC_VECTOR (11 downto 0);
    da_b  =>: in STD_LOGIC_VECTOR (11 downto 0);
    pmod  =>: out STD_LOGIC_VECTOR (3 downto 0);
    clk   =>: in STD_LOGIC
  );*/

end behavioral;