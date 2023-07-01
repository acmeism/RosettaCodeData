with Ada.Text_IO, Population_Count; use Ada.Text_IO; use Population_Count;

procedure Test_Pop_Count is

   X: Num; use type Num;

begin
   Put("Pop_Cnt(3**i):"); -- print pop_counts of powers of three
   X := 1; -- X=3**0
   for I in 1 .. 30 loop
      Put(Natural'Image(Pop_Count(X)));
      X := X * 3;
   end loop;
   New_Line;

   Put("Evil:         ");    -- print first thirty evil numbers
   X := 0;
   for I in 1 .. 30 loop
      while Pop_Count(X) mod 2 /= 0 loop -- X is not evil
         X := X + 1;
      end loop;
      Put(Num'Image(X));
      X := X + 1;
   end loop;
   New_Line;

   Put("Odious:       "); -- print thirty oudous numbers
   X := 1;
   for I in 1 .. 30 loop
      while Pop_Count(X) mod 2 /= 1 loop -- X is not odious
         X := X + 1;
      end loop;
      Put(Num'Image(X));
      X := X + 1;
   end loop;
   New_Line;
end Test_Pop_Count;
