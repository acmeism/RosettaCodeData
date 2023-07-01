with Ada.Text_IO; use Ada.Text_IO;
procedure Main is
	type Bell_Triangle is array(Positive range <>, Positive range <>) of Natural;
	
	
	procedure Print_Rows (Row : in Positive; Triangle : in Bell_Triangle) is
		begin
			if Row in Triangle'Range(1) then
				for I in Triangle'First(1) .. Row loop
					Put_Line (Triangle (I, 1)'Image);
				end loop;
			end if;
	end Print_Rows;
	
	procedure Print_Triangle (Num : in Positive; Triangle : in Bell_Triangle) is
		begin
			if Num in Triangle'Range then
				for I in Triangle'First(1) .. Num loop
					for J in Triangle'First(2) .. Num loop
						if Triangle (I, J) /= 0 then
							Put (Triangle (I, J)'Image);
						end if;
					end loop;
					New_Line;
				end loop;
			end if;
	end Print_Triangle;
	
	procedure Bell_Numbers is
		Triangle : Bell_Triangle(1..15, 1..15) := (Others => (Others => 0));
		Temp     : Positive := 1;
		begin
			
			Triangle (1, 1) := 1;
			
			for I in Triangle'First(1) + 1 .. Triangle'Last(1) loop
				Triangle (I, 1) := Temp;
				
				for J in Triangle'First(2) .. Triangle'Last(2) - 1 loop
					if Triangle (I - 1, J) /= 0 then
						Triangle (I, J + 1) := Triangle (I, J) + Triangle (I - 1, J);
					else
						Temp := Triangle (I, J);
						exit;
					end if;
				end loop;
			end loop;
			
			Put_Line ("First 15 Bell numbers:");
			Print_Rows (15, Triangle);
			
			New_Line;
			
			Put_Line ("First 10 rows of the Bell triangle:");
			Print_Triangle (10, Triangle);
	end Bell_Numbers;
begin
	Bell_Numbers;
end Main;
