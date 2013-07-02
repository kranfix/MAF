library ieee;
use ieee.std_logic_1164.all;

entity dac121s101 is
Port(
  clk:  in  std_logic;
  go:   in  std_logic;
  da_a: in  std_logic_vector(11 downto 0);
  da_b: in  std_logic_vector(11 downto 0);
  pmod: out std_logic_vector(3 downto 0)
);
end dac121s101;
 
architecture Behavioral of dac121s101 is
  signal sync_n,sclk: std_logic := '1';
  signal d_a, d_b: std_logic_vector(11 downto 0);
  signal sr_a, sr_b: std_logic_vector(15 downto 0);
  signal goo, clear_goo: std_logic := '0';
  signal mygoo: std_logic_vector(1 downto 0);
  type t_state is (s_idle, s_wait, s_run);
  signal state: t_state := s_idle;

begin
  pmod(0) <= sync_n; pmod(1) <= sr_a(15);
  pmod(2) <= sr_b(15); pmod(3) <= sclk;

process(go, clear_goo) is begin
  if clear_goo = '1' then goo <= '0';
  elsif rising_edge(go) then
    d_a <= da_a; d_b <= da_b; -- copy input values
    goo <= '1'; -- note go happened
  end if;
end process;
-- main process goes here

process(clk, da_a, da_b) is
  variable counter: integer range 0 to 15 := 0;
begin
  if rising_edge(clk) then
    sclk <= not sclk; -- generate clk/2 shift clock
    mygoo <= mygoo(0) & goo; -- sample go signal
    case state is
    when s_idle =>
      sclk <= '1'; -- hold DA clock high
      if mygoo = "01" then -- rising edge test
        sr_a <= "0000" & not d_a(11) & d_a(10 downto 0);
        sr_b <= "0000" & not d_b(11) & d_b(10 downto 0);
        counter := 0;
        sync_n <= '0';
        sclk <= '0';
        clear_goo <= '1';
        state <= s_wait;
      end if;
    when s_wait =>
      clear_goo <= '0';
      state <= s_run;
      when s_run =>
      if sclk = '0' then
        sr_a <= sr_a(14 downto 0) & '0';
        sr_b <= sr_b(14 downto 0) & '0';
        counter := counter + 1;
        if counter = 15 then
          sync_n <= '1';
          state <= s_idle;
        end if;
      end if;
    end case;
  end if;
end process;
end Behavioral;