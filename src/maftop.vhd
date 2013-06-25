/* Moving Average Filter
file: maftop.vhd
author: Frank Andre Moreno vera
e-mail: frank.moreno@ieee.com
*/
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mafpack.all;

entity maftop is
  generic(M: natural := 10);
  port(
    clk,clr: std_logic;
    y: out number;
    ADC_CLK: in std_logic;
    ADC_SDAT: in std_logic;
    ADC_SADDR: out std_logic;
    ADC_SCLK: out std_logic;
    ADC_CS_N: out std_logic
  );
end entity;

architecture behavioral of maftop is
  constant ADC_ADDR: std_logic_vector(2 downto 0) := "000";
  signal filter_clk: std_logic;
  signal ADC_DATA: std_logic_vector(11 downto 0);
  signal x: number;
  signal h: numbers(0 to M);
begin

ADC_reading: entity work.adc128s022
  port map(
    EN_N       => not clr,
    clk        => clk,
    ADC_ADDR   => ADC_ADDR,
    ADC_SADDR  => ADC_SADDR,
    ADC_SDAT   => ADC_SDAT,
    ADC_DATA   => ADC_DATA,
    ADC_SCLK   => ADC_SCLK,
    ADC_CS_N   => ADC_CS_N,
    filter_clk => filter_clk
  );
  
Asign_x: process(ADC_DATA)
begin
  x <= (others => '0'); 
  for i in ADC_DATA'range loop
    if(ADC_DATA(i) = '1') then
      x(i+4) <= '1';
    end if;
  end loop;
end process;

Operations: block
begin
h(0) <= h(1) + x;   -- h[n] = x[n] + h[n-1]
y <= h(0) - h(M-1); -- y[n] = h[n] - h[n+1-M]
end block;

delays: entity work.delayer
  generic map(ord => M)
  port map( 
    clk    => filter_clk,
    clr    => clr,
    input  => h(0),
    output => h(1 to M)
  );

end behavioral;