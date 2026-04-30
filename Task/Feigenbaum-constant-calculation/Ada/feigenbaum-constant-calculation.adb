with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
   procedure feigenbaum is
      subtype i_range is Integer range 2 .. 13;
      subtype j_range is Integer range 1 .. 10;

      -- the number of digits in type Real is reduced to 15 to produce the
      -- results reported by C, C++, C# and Ring. Increasing the number of
      -- digits in type Real produces the results reported by D.

      type Real is digits 15;
      package Real_Io is new Float_IO (Real);
      use Real_Io;

      a, x, y, d : Real;
      a1         : Real := 1.0;
      a2         : Real := 0.0;
      d1         : Real := 3.2;
   begin
      Put_Line (" i       d");
      for i in i_range loop
         a := a1 + (a1 - a2) / d1;
         for j in j_range loop
            x := 0.0;
            y := 0.0;
            for k in 1 .. 2**i loop
               y := 1.0 - 2.0 * x * y;
               x := a - x * x;
            end loop;
            a := a - x / y;
         end loop;
         d := (a1 - a2) / (a - a1);
         Put (Item => i, Width => 2);
         Put (Item => d, Fore => 5, Aft => 8, Exp => 0);
         New_Line;
         d1 := d;
         a2 := a1;
         a1 := a;
      end loop;
   end feigenbaum;

begin
   feigenbaum;
end Main;
