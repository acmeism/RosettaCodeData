with Ada.Text_Io;

procedure Cousin_Primes is

   type Number is new Long_Integer range 0 .. Long_Integer'Last;
   package Number_Io is new Ada.Text_Io.Integer_Io (Number);

   function Is_Prime (A : Number) return Boolean is
      D : Number;
   begin
      if A < 2       then return False; end if;
      if A in 2 .. 3 then return True;  end if;
      if A mod 2 = 0 then return False; end if;
      if A mod 3 = 0 then return False; end if;
      D := 5;
      while D * D <= A loop
         if A mod D = 0 then
            return False;
         end if;
         D := D + 2;
         if A mod D = 0 then
            return False;
         end if;
         D := D + 4;
      end loop;
      return True;
   end Is_Prime;

   use Ada.Text_Io;
   Count : Natural := 0;
begin
   for N in Number range 1 .. 999 - 4 loop
      if Is_Prime (N) and then Is_Prime (N + 4) then
         Count := Count + 1;
         Put("[");
         Number_Io.Put (N, Width => 3); Put (",");
         Number_Io.Put (N + 4, Width => 3);
         Put("]  ");
         if Count mod 8 = 0 then
            New_Line;
         end if;
      end if;
   end loop;
   New_Line;
   Put_Line (Count'Image & " pairs.");
end Cousin_Primes;
