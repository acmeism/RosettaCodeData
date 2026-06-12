with Ada.Text_IO; use Ada.Text_IO;

procedure Find_Square_Difference is
   Last   : Natural := 0;
   Square : Positive;
   Diff   : Positive;
begin
   for N in 1 .. Positive'Last loop
      Square := N ** 2;
      Diff   := Square - Last;
      Last   := Square;
      if Diff > 1000 then
         Put_Line (N'Image);
         exit;
      end if;
   end loop;
end Find_Square_Difference;
