with Ada.Containers.Ordered_Sets, Ada.Text_IO;
use Ada.Text_IO;

procedure Duplicate is	
	package Int_Sets is new Ada.Containers.Ordered_Sets (Integer);
	Nums : constant array (Natural range <>) of Integer := (1,2,3,4,5,5,6,7,1);
	Unique : Int_Sets.Set;
begin
	for n of Nums loop
		Unique.Include (n);
	end loop;
	for e of Unique loop
		Put (e'img);
	end loop;
end Duplicate;
