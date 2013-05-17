/*Moving Average Filter
author: Frank Andre Moreno vera
e-mail: frank.moreno@gmail.com
*/
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_types.all;

entity maf is
generic(N: natural := 10);
port(
	clk,clr: std_logic;
	x: in number;
	y: out number
);
end entity;

architecture behavioral of maf is
	signal h: numbers(0 to N-1);
begin

h(0) <= h(1) + x;
y <= h(0) - h(N-1);

delays: entity work.delayer
	generic map(ord => N-1)
	port map( 
		clk	=> clk,
		clr	=> clr,
		input	=> h(0),
		output=> h(1 to N-1)
	);

end behavioral;