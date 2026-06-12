with Ada.Text_IO;

procedure Prime_Fibonacci is

   function Is_Prime (A : Natural) return Boolean is
      D : Natural;
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

   F_1   : Natural := 0;
   F_2   : Natural := 1;

   function Fibonacci return Natural is
      R : Natural := F_1 + F_2;
   begin
      F_1 := F_2;
      F_2 := R;
      return R;
   end Fibonacci;

   Count : Natural := 0;
   Fib   : Natural;
begin
   while Count < 9 loop
      Fib := Fibonacci;
      if Is_Prime (Fib) then
         Count := Count + 1;
         Ada.Text_IO.Put_Line (Fib'Image);
      end if;
   end loop;
end Prime_Fibonacci;
