LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity four_bit_adder is
   port(
      a : in     std_logic_vector (3 downto 0);
      b : in     std_logic_vector (3 downto 0);
      s : out    std_logic_vector (3 downto 0);
      v : out    std_logic
   );
end four_bit_adder ;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity fa is
   port(
      a  : in     std_logic;
      b  : in     std_logic;
      ci : in     std_logic;
      co : out    std_logic;
      s  : out    std_logic
   );
end fa ;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity ha is
   port(
      a : in     std_logic;
      b : in     std_logic;
      c : out    std_logic;
      s : out    std_logic
   );
end ha ;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity xor_gate is
   port(
      a : in     std_logic;
      b : in     std_logic;
      x : out    std_logic
   );
end xor_gate ;



architecture struct of four_bit_adder is
   signal ci0 : std_logic;
   signal co0 : std_logic;
   signal co1 : std_logic;
   signal co2 : std_logic;

   component fa
   port (
      a  : in     std_logic ;
      b  : in     std_logic ;
      ci : in     std_logic ;
      co : out    std_logic ;
      s  : out    std_logic
   );
   end component;
begin
   ci0 <= '0';

   i_fa0 : fa
      port map (
         a  => a(0),
         b  => b(0),
         ci => ci0,
         co => co0,
         s  => s(0)
      );
   i_fa1 : fa
      port map (
         a  => a(1),
         b  => b(1),
         ci => co0,
         co => co1,
         s  => s(1)
      );
   i_fa2 : fa
      port map (
         a  => a(2),
         b  => b(2),
         ci => co1,
         co => co2,
         s  => s(2)
      );
   i_fa3 : fa
      port map (
         a  => a(3),
         b  => b(3),
         ci => co2,
         co => v,
         s  => s(3)
      );

end struct;


architecture struct of fa is
   signal c1 : std_logic;
   signal c2 : std_logic;
   signal s1 : std_logic;

   component ha
   port (
      a : in     std_logic ;
      b : in     std_logic ;
      c : out    std_logic ;
      s : out    std_logic
   );
   end component;
begin
   co <= c1 or c2;

   i_ha0 : ha
      port map (
         a => ci,
         b => a,
         c => c1,
         s => s1
      );
   i_ha1 : ha
      port map (
         a => s1,
         b => b,
         c => c2,
         s => s
      );
end struct;


architecture struct of ha is
   component xor_gate
   port (
      a : in     std_logic;
      b : in     std_logic;
      x : out    std_logic
   );
   end component;
begin
   c <= a and b;

   i_xor_gate : xor_gate
      port map (
         a => a,
         b => b,
         x => s
      );
end struct;


architecture rtl of xor_gate is
begin
  x <= (a and not b) or (b and not a);
end architecture rtl;
