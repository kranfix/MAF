/* ADC Reader
file:	adc128s022.vhd
author: Frank Andre Moreno vera
e-mail: frankmoreno1993@gmail.com
*/
library ieee;
use ieee.std_logic_1164.all;

entity adc128s022 is
port(
  en_n:       in std_logic;
  ad_sclk:    in std_logic;
  ad_sdat:    in std_logic;
  ad_addr:    in std_logic_vector(2 downto 0);
  ad_saddr:   out std_logic;
  ad_data:    out std_logic_vector(11 downto 0);
  ad_cs_n:    buffer std_logic;
  sample_clk: buffer std_logic
);
end adc128s022;

architecture adc_reader of adc128s022 is
  signal cycle: integer range 0 to 15:= 0;
begin

-- EN_N to ADC_CS_N and clk to filter_clk
process(en_n,ad_sclk)
  variable i: integer range 0 to 15 := 0;
begin
  if(EN_N = '1') then
    ad_cs_n <= '1';
    sample_clk <= '0';
    cycle <= 0;
    i := 0;
  elsif falling_edge(ad_sclk) then
    cycle <= i; 
    ad_cs_n <= '0';
    if (cycle = 0 or cycle = 8) then
      sample_clk <= not sample_clk;
    end if;
    i := i + 1;
  end if;
end process;

-- ADC_SADDR to ADC_ADDR
process(ad_cs_n,ad_sclk)
begin
  if(ad_cs_n = '1') then
    ad_saddr <= 'Z';
  elsif falling_edge(ad_sclk) then
    if(cycle > 0 or cycle < 4) then
      ad_saddr <= ad_addr(3-cycle);
    else
      ad_saddr <= '0';
    end if;
  end if;
end process;

-- ADC_SDAT to ADC_DATA
process(en_n,ad_sclk)
begin
  if(ad_cs_n = '1') then
    ad_data <= (others => 'Z');
  elsif rising_edge(ad_sclk) then
    if (cycle > 3) then
      ad_data(15-cycle) <= ad_sdat;
    end if;
  end if;
end process;

end adc_reader;