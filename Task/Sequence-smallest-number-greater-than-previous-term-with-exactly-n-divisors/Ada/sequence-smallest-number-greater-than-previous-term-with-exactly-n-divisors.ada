with Ada.Text_IO;

procedure Show_Sequence is

   function Count_Divisors (N : in Natural) return Natural is
      Count : Natural := 0;
      I     : Natural;
   begin
      I := 1;
      while I**2 <= N loop
         if N mod I = 0 then
            if I = N / I then
               Count := Count + 1;
            else
               Count := Count + 2;
            end if;
         end if;
         I := I + 1;
      end loop;

      return Count;
   end Count_Divisors;

   procedure Show (Max : in Natural) is
      use Ada.Text_IO;
      N : Natural := 1;
   Begin
      Put_Line ("The first" & Max'Image & "terms of the sequence are:");
      for Divisors in 1 .. Max loop
         while Count_Divisors (N) /= Divisors loop
            N := N + 1;
         end loop;
         Put (N'Image);
      end loop;
      New_Line;
   end Show;

begin
   Show (15);
end Show_Sequence;
