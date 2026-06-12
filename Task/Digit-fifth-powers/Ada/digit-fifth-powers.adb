with Ada.Text_Io;

procedure Digit_Fifth_Powers is

   subtype Number is Natural range 000_002 .. 999_999;

   function Sum_5 (N : Natural) return Natural
   is
      Pow_5 : constant array (0 .. 9) of Natural :=
        (0 => 0**5, 1 => 1**5, 2 => 2**5, 3 => 3**5, 4 => 4**5,
         5 => 5**5, 6 => 6**5, 7 => 7**5, 8 => 8**5, 9 => 9**5);
   begin
      return (if N = 0
              then 0
              else Pow_5 (N mod 10) + Sum_5 (N / 10));
   End Sum_5;

   use Ada.Text_Io;
   Sum : Natural := 0;
begin
   for N in Number loop
      if N = Sum_5 (N) then
         Sum := Sum + N;
         Put_Line (Number'Image (N));
      end if;
   end loop;
   Put ("Sum: ");
   Put_Line (Natural'Image (Sum));
end Digit_Fifth_Powers;
