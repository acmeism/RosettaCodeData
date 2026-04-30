LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity b2g is
   port(  bin  : in  std_logic_vector (4 downto 0);
          gray : out std_logic_vector (4 downto 0)
        );
end b2g ;

architecture rtl of b2g is
  constant N : integer := bin'high;
begin
  gray <= bin(n) & ( bin(N-1 downto 0) xor bin(N downto 1));
end architecture rtl;
