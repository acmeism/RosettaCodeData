with Ada.Text_Io;

procedure Additive_Primes is

   Last    : constant := 499;
   Columns : constant := 12;

   type Prime_List is array (2 .. Last) of Boolean;

   function Get_Primes return Prime_List is
      Prime : Prime_List := (others => True);
   begin
      for P in Prime'Range loop
         if Prime (P) then
            for N in 2 .. Positive'Last loop
               exit when N * P not in Prime'Range;
               Prime (N * P) := False;
            end loop;
         end if;
      end loop;
      return Prime;
   end Get_Primes;

   function Sum_Of (N : Natural) return Natural is
      Image : constant String := Natural'Image (N);
      Sum   : Natural := 0;
   begin
      for Char of Image loop
         Sum := Sum + (if Char in '0' .. '9'
                       then Natural'Value ("" & Char)
                       else 0);
      end loop;
      return Sum;
   end Sum_Of;

   package Natural_Io is new Ada.Text_Io.Integer_Io (Natural);
   use Ada.Text_Io, Natural_Io;

   Prime : constant Prime_List := Get_Primes;
   Count : Natural := 0;
begin
   Put_Line ("Additive primes <500:");
   for N in Prime'Range loop
      if Prime (N) and then Prime (Sum_Of (N)) then
         Count := Count + 1;
         Put (N, Width => 5);
         if Count mod Columns = 0 then
            New_Line;
         end if;
      end if;
   end loop;
   New_Line;

   Put ("There are ");
   Put (Count, Width => 2);
   Put (" additive primes.");
   New_Line;
end Additive_Primes;
