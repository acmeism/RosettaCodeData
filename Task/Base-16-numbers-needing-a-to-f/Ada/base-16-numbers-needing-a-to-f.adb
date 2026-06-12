with Ada.Text_Io;

procedure Base_16_Numbers is
   Columns : constant := 24;
   Base    : constant := 16;

   function Has_A_To_F (N : Positive) return Boolean is
      C : Natural := N;
   begin
      while C > 0 loop
         if C mod Base in 16#A# .. 16#F# then
            return True;
         end if;
         C := C / Base;
      end loop;
      return False;
   end Has_A_To_F;

   package Natural_Io is new Ada.Text_Io.Integer_Io (Natural);
   use Ada.Text_Io;
   Count : Natural := 0;
begin
   for N in 1 .. 500 loop
      if Has_A_To_F (N) then
         Count := Count + 1;
         Natural_Io.Put (N, Width => 5);
         if Count mod Columns = 0 then
            New_Line;
         end if;
      end if;
   end loop;
   New_Line (2);
   Put ("Total count: "); Natural_Io.Put (Count, Width => 3); New_Line;
end Base_16_Numbers;
