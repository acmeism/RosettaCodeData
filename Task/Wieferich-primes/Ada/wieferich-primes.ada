with Ada.Text_IO;

procedure Wieferich_Primes is

   function Is_Prime (V : Positive) return Boolean is
      D : Positive := 5;
   begin
      if V < 2       then return False; end if;
      if V mod 2 = 0 then return V = 2; end if;
      if V mod 3 = 0 then return V = 3; end if;
      while D * D <= V loop
         if V mod D = 0 then
            return False;
         end if;
         D := D + 2;
      end loop;
      return True;
   end Is_Prime;

   function Is_Wieferich (N : Positive) return Boolean is
      Q : Natural := 1;
   begin
      if not Is_Prime (N) then
         return False;
      end if;
      for P in 2 .. N loop
         Q := (2 * Q) mod N**2;
      end loop;
      return Q = 1;
   end Is_Wieferich;

begin

   Ada.Text_IO.Put_Line ("Wieferich primes below 5000:");
   for N in 1 .. 4999 loop
      if Is_Wieferich (N) then
         Ada.Text_IO.Put_Line (N'Image);
      end if;
   end loop;

end Wieferich_Primes;
