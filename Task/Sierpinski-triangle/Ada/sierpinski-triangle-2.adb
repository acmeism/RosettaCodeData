with Ada.Command_Line;
with Ada.Text_IO;

procedure Main is
   subtype Order is Natural range 1 .. 32;
   type Mod_Int is mod 2 ** Order'Last;

   procedure Sierpinski (N : Order) is
   begin
      for Line in Mod_Int range 0 .. 2 ** N - 1 loop
         for Col in Mod_Int range 0 .. 2 ** N - 1 loop
            if (Line and Col) = 0 then
               Ada.Text_IO.Put ('X');
            else
               Ada.Text_IO.Put (' ');
            end if;
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Sierpinski;

   N : Order := 4;
begin
   if Ada.Command_Line.Argument_Count = 1 then
      N := Order'Value (Ada.Command_Line.Argument (1));
   end if;
   Sierpinski (N);
end Main;
