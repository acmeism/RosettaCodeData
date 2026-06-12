with Ada.Text_Io;

procedure Extra_Primes is

   type Number   is new Long_Integer range 0 .. Long_Integer'Last;

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

   subtype Digit is Number range 0 .. 9;
   type Digit_Array is array (Positive range <>) of Digit;

   function To_Digits (N : Number) return Digit_Array is
      Image : constant String := Number'Image (N);
      Res   : Digit_Array (2 .. Image'Last);
   begin
      for A in Image'First + 1 .. Image'Last loop
         Res (A) := Character'Pos (Image (A)) - Character'Pos ('0');
      end loop;
      return Res;
   end To_Digits;

   function All_Prime (Dig : Digit_Array) return Boolean is
     (for all D of Dig => Is_Prime (D));

   function Sum_Of (Dig : Digit_Array) return Number is
      Sum : Number := 0;
   begin
      for D of Dig loop
         Sum := Sum + D;
      end loop;
      return Sum;
   end Sum_Of;

   use Ada.Text_Io;
   Count : Natural := 0;
begin
   for N in Number range 1 .. 9_999 loop
      if Is_Prime (N) then
         declare
            Dig : constant Digit_Array := To_Digits (N);
         begin
            if All_Prime (Dig) and Is_Prime (Sum_Of (Dig)) then
               Count := Count + 1;
               Number_Io.Put (N, Width => 4); Put ("  ");
               if Count mod 8 = 0 then
                  New_Line;
               end if;
            end if;
         end;
      end if;
   end loop;
   New_Line;
   Put_Line (Count'Image & " extra primes.");
end Extra_Primes;
