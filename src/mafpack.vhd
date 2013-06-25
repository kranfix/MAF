/* file: mafpack.vhd
author: Frank Andre Moreno vera
e-mail: frankmoreno1993@gmail.com
*/
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mafpack is
  subtype number is signed(15 downto 0);
  type numbers is array(natural range <>) of number;
end mafpack;