library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DOORS is
	port (CLK: in std_logic; OUTPUT: out std_logic_vector(1 to 100));
end DOORS;

architecture Behavioral of DOORS is
begin
	process (CLK)
	variable TEMP: std_logic_vector(1 to 100);
	begin
		--setup closed doors
		TEMP := (others => '0');
		
		--looping through
		for i in 1 to TEMP'length loop
			for j in i to TEMP'length loop
				if (j mod i) = 0 then
					TEMP(j) := not TEMP(j);
				end if;
			end loop;
		end loop;
		
		--assign output
		OUTPUT <= TEMP;
	end process;
end Behavioral;
