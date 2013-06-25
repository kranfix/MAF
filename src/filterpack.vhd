/* Package to define types
file:   mafpack.vhd
author: Frank Andre Moreno vera
e-mail: frankmoreno1993@gmail.com
*/
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package filterpack is
  subtype number is signed(15 downto 0);
  type numbers is array(natural range <>) of number;
  function DATA_TO_X(signal ADC_DATA: in std_logic_vector) return number;
  procedure MAF_filter(signal x: in number; signal h: inout numbers; signal y: out number);
end filterpack;

package body filterpack is

function DATA_TO_X(signal ADC_DATA: in std_logic_vector) return number is
  variable x: number := (others => '0');
begin
  for i in ADC_DATA'range loop
    if(ADC_DATA(i) = '1') then
      x(i+4) := '1';
    end if;
  end loop;
  return x;
end function DATA_TO_X;

procedure MAF_filter(
    signal x: in number;
    signal h: inout numbers;
    signal  y: out number
  ) is
begin
  h(0) <= h(1) + x;   -- h[n] = x[n] + h[n-1]
  y <= h(0) - h(M-1); -- y[n] = h[n] - h[n+1-M]
end MAF_filter;

end package body filterpack;