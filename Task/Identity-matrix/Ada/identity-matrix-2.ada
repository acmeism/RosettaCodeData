type Matrix is array(Positive Range <>, Positive Range <>) of Integer;
mat : Matrix(1..5,1..5) := (others => (others => 0));
--  then after the declarative section:
for i in mat'Range(1) loop mat(i,i) := 1; end loop;
