with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Main is
   package int_vector is new Ada.Containers.Vectors
     (Index_Type => Natural, Element_Type => Integer);
   use int_vector;

   summing_values : Vector := Empty_Vector;

   prod : Integer := 1;
   sum  : Integer := 0;
   x    : Integer := 5;
   y    : Integer := -5;
   z    : Integer := -2;
   N    : Integer;
begin
   N := -3;
   while N <= 3**3 loop
      summing_values.Append (N);
      N := N + 3;
   end loop;

   N := -7;
   while N <= 7 loop
      summing_values.Append (N);
      N := N + x;
   end loop;

   for I in 555 .. 550 - y loop
      summing_values.Append (I);
   end loop;

   N := 22;
   while N >= -28 loop
      summing_values.Append (N);
      N := N - 3;
   end loop;

   for I in 1_927 .. 1_939 loop
      summing_values.Append (I);
   end loop;

   N := x;
   while N >= y loop
      summing_values.Append (N);
      N := N + z;
   end loop;

   for I in 11**x .. 11**x + 1 loop
      summing_values.Append (I);
   end loop;

   for value of summing_values loop
      sum := sum + abs (value);
      if abs (prod) < 2**27 and then value /= 0 then
         prod := prod * value;
      end if;
   end loop;

   Put_Line ("sum = " & sum'Image);
   Put_Line ("prod = " & prod'Image);

end Main;
