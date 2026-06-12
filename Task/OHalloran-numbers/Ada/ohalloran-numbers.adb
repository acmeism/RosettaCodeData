with Ada.Text_IO; use Ada.Text_IO;

procedure Ohalloran_Numbers is
   Min_Area : constant Integer := 6;
   Max_Area : constant Integer := 1000;
   Half_Max : constant Integer := Max_Area / 2;
   Area     : Integer;
   type Areas_Array is array (Min_Area .. Max_Area) of Boolean;
   Areas : Areas_Array := (others => True);
begin
   for I in 1 .. Max_Area loop
      for J in 1 .. Half_Max loop
         exit when I * J > Half_Max;
         for K in 1 .. Half_Max loop
            Area := 2 * ((I * J) + (I * K) + (J * K));
            exit when Area > Max_Area;
            Areas (Area) := False;
         end loop;
      end loop;
   end loop;
   Put_Line ("O'Halloran numbers less than" & Max_Area'Image);
   for I in Min_Area .. Max_Area loop
      if I mod 2 = 0 and then Areas (I) then
         Put (I'Image);
      end if;
   end loop;
end Ohalloran_Numbers;
