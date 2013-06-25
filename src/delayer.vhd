/* Order 'ord' Delayer
file: delayer.vhd
author: Frank Andre Moreno vera
e-mail: frankmoreno1993@gmail.com
*/
library ieee;
use ieee.std_logic_1164.all;
use work.mafpack.all;

entity delayer is
generic(ord: natural := 10);
port(
  clk,clr: in std_logic;
  input: in number;
  output: buffer numbers(1 to ord)
);
end entity;

architecture orderN of delayer is
begin

process(all)
begin
  if clr then
    output <= (others => (others => '0'));
  elsif rising_edge(clk) then
    output(1) <= input;
    for i in 1 to output'high-1 loop
      output(i+1) <= output(i);
    end loop;
  end if;
end process;

end orderN;