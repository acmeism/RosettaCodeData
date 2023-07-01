LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity g2b is
   port(  gray : in     std_logic_vector (4 downto 0);
          bin  : buffer std_logic_vector (4 downto 0)
        );
end g2b ;

architecture rtl of g2b is
  constant N : integer := bin'high;
begin
  bin(N) <= gray(N);
  gen_xor: for i in N-1 downto 0 generate
    bin(i) <= gray(i) xor bin(i+1);
  end generate;
end architecture rtl;
