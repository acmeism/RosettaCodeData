with Ada.Text_IO, Ada.Command_Line;
use Ada.Text_IO, Ada.Command_Line;

procedure powerset is
begin
	for set in 0..2**Argument_Count-1 loop
		Put ("{");			
		declare
			k : natural := set;
			first : boolean := true;
		begin
			for i in 1..Argument_Count loop
				if k mod 2 = 1 then
					Put ((if first then "" else ",") & Argument (i));
					first := false;
			  	end if;
				k := k / 2; -- we go to the next bit of "set"
			end loop;
		end;
		Put_Line("}");
	end loop;
end powerset;
