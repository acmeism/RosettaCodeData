with Ada.Text_IO; use Ada.Text_IO;

procedure Strange_Numbers is

   function Is_Strange (A : Natural) return Boolean is
      Last     : Natural := A mod 10;
      Reminder : Natural := A / 10;
      Current  : Natural;
   begin
      while Reminder /= 0 loop
         Current := Reminder mod 10;
         exit when abs (Current - Last) not in 2 | 3 | 5 | 7;
         Last     := Current;
         Reminder := Reminder / 10;
      end loop;
      return Reminder = 0;
   end Is_Strange;

   Count : Natural := 0;
begin
   for A in 101 .. 499 loop
      if Is_Strange (A) then
         Put (A'Image);
         Count := Count + 1;
         if Count mod 10 = 0 then
            New_Line;
         end if;
      end if;
   end loop;
   New_Line;
   Put_Line ("Strange numbers in range 101 .. 499: " & Count'Image);
   New_Line;

   Count := 0;
   for A in 1_000_000_000 .. 1_999_999_999 loop
      if Is_Strange (A) then
         Count := Count + 1;
      end if;
   end loop;
   Put_Line ("Strange numbers in range 1_000_000_000 .. 1_999_999_999: " & Count'Image);
end Strange_Numbers;
