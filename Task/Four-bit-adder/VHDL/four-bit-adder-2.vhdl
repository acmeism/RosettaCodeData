LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

entity tb is
end tb ;


architecture struct of tb is
   signal a : std_logic_vector(3 downto 0);
   signal b : std_logic_vector(3 downto 0);
   signal s : std_logic_vector(3 downto 0);
   signal v : std_logic;

   component four_bit_adder
   port (
      a : in     std_logic_vector (3 downto 0);
      b : in     std_logic_vector (3 downto 0);
      s : out    std_logic_vector (3 downto 0);
      v : out    std_logic
   );
   end component;
begin

   proc_test: process
   begin
     for x in 0 to 15 loop
       for y in 0 to 15 loop
         a <= std_logic_vector(to_unsigned(x, 4));
         b <= std_logic_vector(to_unsigned(y, 4));
         wait for 100 ns;
       end loop;
     end loop;
     wait;
   end process;

   i_four_bit_adder : four_bit_adder
      port map (
         a => a,
         b => b,
         s => s,
         v => v
      );

end struct;
