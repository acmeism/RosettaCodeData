LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Factorial IS
	GENERIC (
			Nbin : INTEGER := 3 ; -- number of bit to input number
			Nbou : INTEGER := 13) ; -- number of bit to output factorial
	
	PORT (
		clk : IN STD_LOGIC ; -- clock of circuit
		sr  : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- set and reset
		N   : IN STD_LOGIC_VECTOR(Nbin-1 DOWNTO 0) ; -- max number
	    Fn  : OUT STD_LOGIC_VECTOR(Nbou-1 DOWNTO 0)); -- factorial of "n"
		  		
END Factorial ;

ARCHITECTURE Behavior OF Factorial IS
---------------------- Program Multiplication --------------------------------
	FUNCTION Mult ( CONSTANT MFa : IN UNSIGNED ;
					CONSTANT MI   : IN UNSIGNED ) RETURN UNSIGNED IS 			
	VARIABLE Z : UNSIGNED(MFa'RANGE) ;
	VARIABLE U : UNSIGNED(MI'RANGE) ;
	BEGIN
	Z := TO_UNSIGNED(0, MFa'LENGTH) ; -- to obtain the multiplication
	U := MI ; -- regressive counter
		LOOP
			Z := Z + MFa ; -- make multiplication
			U := U - 1 ;
			EXIT WHEN U = 0 ;
		END LOOP ;
		RETURN Z ;
	END Mult ;
-------------------Program Factorial ---------------------------------------
	FUNCTION Fact (CONSTANT Nx : IN NATURAL ) RETURN UNSIGNED IS
	VARIABLE C  : NATURAL RANGE 0 TO 2**Nbin-1 ;
	VARIABLE I  : UNSIGNED(Nbin-1 DOWNTO 0) ;
	VARIABLE Fa : UNSIGNED(Nbou-1 DOWNTO 0) ;
	BEGIN
		C := 0 ; -- counter
		I :=  TO_UNSIGNED(1, Nbin) ;
		Fa := TO_UNSIGNED(1, Nbou) ;	
		LOOP
			EXIT WHEN C = Nx ; -- end loop
			C := C + 1 ;  -- progressive couter
			Fa := Mult (Fa , I ); -- call function to make a multiplication
			I := I + 1 ; --
		END LOOP ;
		RETURN Fa ;
	END Fact ;
--------------------- Program TO Call Factorial Function ------------------------------------------------------
	TYPE Table IS ARRAY (0 TO 2**Nbin-1) OF UNSIGNED(Nbou-1 DOWNTO 0) ;
	FUNCTION Call_Fact RETURN Table IS
	VARIABLE Fc : Table ;
	BEGIN
		FOR c IN 0 TO 2**Nbin-1 LOOP
			Fc(c) := Fact(c) ;		
		END LOOP ;
		RETURN Fc ;
	END FUNCTION Call_Fact;
	
	CONSTANT Result : Table := Call_Fact ;
 ------------------------------------------------------------------------------------------------------------
SIGNAL Nin : STD_LOGIC_VECTOR(N'RANGE) ;
BEGIN    -- start of architecture


Nin <= N               WHEN RISING_EDGE(clk) AND sr = "10" ELSE
       (OTHERS => '0') WHEN RISING_EDGE(clk) AND sr = "01" ELSE
	   UNAFFECTED;

Fn <= STD_LOGIC_VECTOR(Result(TO_INTEGER(UNSIGNED(Nin)))) WHEN RISING_EDGE(clk) ;

END Behavior ;
