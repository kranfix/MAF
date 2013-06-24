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
		x: in number;
		y: out number
	);
end entity;

architecture behavioral of maftop is
	signal h: numbers(0 to M-1);
begin

h(0) <= h(1) + x;		-- h[n] = x[n] + h[n-1]
y <= h(0) - h(M-1);	-- y[n] = h[n] - h[n+1-M]

delays: entity work.delayer
	generic map(ord => N-1)
	port map( 
		clk	=> clk,
		clr	=> clr,
		input	=> h(0),
		output=> h(1 to N-1)
	);

end behavioral;