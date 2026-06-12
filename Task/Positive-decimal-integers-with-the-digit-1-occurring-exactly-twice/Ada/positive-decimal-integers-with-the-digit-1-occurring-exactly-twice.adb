with Ada.Text_IO; use Ada.Text_IO;

procedure Positives_With_1_Twice is

   function One_Twice (N : Positive) return Boolean is
      NN        : Natural := N;
      One_Count : Natural := 0;
   begin
      while NN > 0 loop
         if NN mod 10 = 1 then
            One_Count := One_Count + 1;
         end if;
         NN := NN / 10;
      end loop;
      return One_Count = 2;
   end One_Twice;

begin
   for N in 1 .. 999 loop
      if One_Twice (N) then
         Put (N'Image); Put (" ");
      end if;
   end loop;
   New_Line;
end Positives_With_1_Twice;
