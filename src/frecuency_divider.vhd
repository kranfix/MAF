/* Frecuency Divider
file:   frecuency_divider.vhd
author: Frank Andre Moreno vera
e-mail: frankmoreno1993@gmail.com
*/
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frecuency_divider is
  generic(
    board_frec:  integer := 50e3; -- in kHz
    whised_frec: integer := 800   -- in khz
  );
  port(
    reset: in std_logic;
    clk_in:  in std_logic;
    clk_out: buffer std_logic
  );
end entity;

architecture divider of frecuency_divider is
  constant num_of_cycles: integer := board_frec/(2*whised_frec);
begin

process(clk_in)
  variable i: integer range 0 to num_of_cycles-1;
begin
  if reset = '1' then
    clk_out <= '0';
    i := 0;
  elsif rising_edge(clk_in) then
    if i = 0 then
      clk_out <= not clk_out;
    end if;
    i := i + 1;
    if i = num_of_cycles then
      i := 0;
    end if;
  end if;
end process;

end architecture divider;