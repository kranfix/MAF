/* ADC Reader
file:	adcreader.vhd
author: Frank Andre Moreno vera
e-mail: frankmoreno1993@gmail.com
*/
library ieee;
use ieee.std_logic_1164.all;
use work.mafpack.all;

entity adc128s022 is
port(
  EN_N,clk: in std_logic;
  ADC_SDAT: in std_logic;
  ADC_ADDR: in std_logic_vector(2 downto 0);
  ADC_SADDR, ADC_SCLK: out std_logic;
  ADC_DATA: out std_logic_vector(11 downto 0);
  ADC_CS_N: buffer std_logic;
  clk_out:	buffer std_logic
);
end adc128s022;

architecture adc_reader of adc128s022 is
  signal cycle: integer range 0 to 15:= 0;
begin

-- EN_N to ADC_CS_N and clk to clk_out
process(EN_N,clk)
	variable i: integer range 0 to 15 := 0;
begin
  if(EN_N = '1') then
    ADC_CS_N <= '1';
	 clk_out <= '0';
	 ADC_SCLK <= '1';
    cycle <= 0;
  elsif falling_edge(clk) then
    cycle <= i; 
    ADC_CS_N <= '0';
	 ADC_SCLK <= clk;
	 if (cycle = 0 or cycle = 8) then
		clk_out <= not clk_out;
	 end if;
	 i := i + 1;
  end if;
end process;

-- ADC_SADDR to ADC_ADDR
process(ADC_CS_N,clk)
begin
	if(ADC_CS_N = '1') then
	  ADC_SADDR <= 'Z';
	  ADC_DATA <= (others => 'Z');
	elsif falling_edge(clk) then
	  if (cycle > 0  or cycle < 4) then
		 ADC_SADDR <= ADC_ADDR(3-cycle);
     else
       ADC_SADDR <= '0';
     end if;
	end if;
end process;

-- ADC_SDAT to ADC_DATA
process(EN_N,clk)
begin
  if(ADC_CS_N = '1') then
    ADC_SADDR <= 'Z';
	 ADC_DATA <= (others => 'Z');
  elsif rising_edge(clk) then
    if (cycle > 3) then
      ADC_DATA(15-cycle) <= ADC_SDAT;
  	 end if;
  end if;
end process;

end adc_reader;