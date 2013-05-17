library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package my_types is
	subtype number is signed(15 downto 0);
	type numbers is array(natural range <>) of number;
end my_types;