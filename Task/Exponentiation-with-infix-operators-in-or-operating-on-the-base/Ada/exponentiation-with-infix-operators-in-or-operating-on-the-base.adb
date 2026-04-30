with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   ivalue : Integer := -5;
   fvalue : float   := -5.0;
begin
   Put_Line("Integer exponentiation:");
   for i in 1..2 loop
      for power in 2..3 loop

         Put("x =" & ivalue'image & " p =" & power'image);
         Put("   -x ** p ");
         Put(item => -ivalue ** power, width => 4);
         Put("   -(x) ** p ");
         Put(item => -(ivalue) ** power, width => 4);
         Put("   (-x) ** p ");
         Put(Item => (- ivalue) ** power, Width => 4);
         Put("   -(x ** p) ");
         Put(Item => -(ivalue ** power), Width => 4);
         New_line;
      end loop;
      ivalue := 5;
      fvalue := 5.0;
   end loop;
   Put_Line("floating point exponentiation:");
   ivalue := -5;
   fvalue := -5.0;

   for i in 1..2 loop
      for power in 2..3 loop
         Put("x =" & fvalue'image & " p =" & power'image);
         Put("   -x ** p ");
         Put(item => -fvalue ** power, fore => 4, Aft => 1, Exp => 0);
         Put("   -(x) ** p ");
         Put(item => -(fvalue) ** power, fore => 4, Aft => 1, Exp => 0);
         Put("   (-x) ** p ");
         Put(Item => (- fvalue) ** power, fore => 4, Aft => 1, Exp => 0);
         Put("   -(x ** p) ");
         Put(Item => -(fvalue ** power), fore => 4, Aft => 1, Exp => 0);
         New_line;
      end loop;
      ivalue := 5;
      fvalue := 5.0;
   end loop;
end Main;
