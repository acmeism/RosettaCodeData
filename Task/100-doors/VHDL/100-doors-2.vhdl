LIBRARY ieee;
USE ieee.std_logic_1164.all;


entity doors is
  port (
        clk   : in std_logic;
        reset : in std_logic;
        door  : buffer std_logic_vector(1 to 100)
        );
end entity doors;


architecture rtl of doors is
  signal step : integer range 1 to 101;
  signal addr : integer range 1 to 201;
begin
  proc_step: process(clk, reset)
  begin
    if reset = '1' then
      step  <= 1;
      addr  <= 1;
      door <= (others => '0');
    elsif rising_edge(clk) then
      if addr <= 100 then
        door(addr) <= not door(addr);
        addr <= addr + step;
      elsif step <= 100 then
        addr <= step + 1;
        step <= step + 1;
      end if;
    end if;
  end process;
end;
