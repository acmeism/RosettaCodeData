with Ada.Text_IO;

procedure Department_Numbers is
   use Ada.Text_IO;
begin
   Put_Line (" P S F");
   for Police in 2 .. 6 loop
      for Sanitation in 1 .. 7 loop
         for Fire in 1 .. 7 loop
            if
              Police mod 2 = 0                and
              Police + Sanitation + Fire = 12 and
              Sanitation /= Police            and
              Sanitation /= Fire              and
              Police     /= Fire
            then
               Put_Line (Police'Image & Sanitation'Image & Fire'Image);
            end if;
         end loop;
      end loop;
   end loop;
end Department_Numbers;
