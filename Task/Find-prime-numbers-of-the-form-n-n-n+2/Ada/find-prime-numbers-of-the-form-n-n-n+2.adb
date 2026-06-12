with Ada.Text_Io;

procedure Find_Primes is

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

   P : Number;
begin
   Ada.Text_Io.Put_Line ("  N   N**3+2");
   Ada.Text_Io.Put_Line ("------------");
   for N in Number range 1 .. 199 loop
      P := N**3 + 2;
      if Is_Prime (P) then
         Number_Io.Put (N, Width => 3); Ada.Text_Io.Put ("  ");
         Number_Io.Put (P, Width => 7);
         Ada.Text_Io.New_Line;
      end if;
   end loop;
end Find_Primes;
