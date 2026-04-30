with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   subtype param_type is Integer range 1 .. 100;
   function lpd (n : in param_type) return param_type is
      result : param_type := 1;
   begin
      for divisor in reverse 1 .. n / 2 loop
         if n rem divisor = 0 then
            result := divisor;
            exit;
         end if;
      end loop;
      return result;
   end lpd;

begin
   for I in param_type loop
      Put (Item => lpd (I), Width => 3);
      if I rem 10 = 0 then
         New_Line;
      end if;
   end loop;
end Main;
