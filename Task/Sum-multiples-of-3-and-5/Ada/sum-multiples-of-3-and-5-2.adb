with Ada.Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers;

procedure Sum_Multiples_Big is
   use Ada.Numerics.Big_Numbers.Big_Integers;
   use Ada.Text_IO;

   type Natural is new Big_Natural;

   function Sum_Mults (First, Last : Natural) return Natural is
      High : constant Natural := Last - Last mod First;
      Sum  : constant Natural := (High / First) * (First + High) / 2;
   begin
      return Sum;
   end Sum_Mults;

   function Sum_35 (Limit : in Natural) return Natural is
      Last    : constant Natural := Limit - 1;
      Mult_3  : constant Natural := Sum_Mults (3,  Last);
      Mult_5  : constant Natural := Sum_Mults (5,  Last);
      Mult_15 : constant Natural := Sum_Mults (15, Last);
   begin
      return Mult_3 + Mult_5 - Mult_15;
   end Sum_35;

begin
   Put_Line ("                               n : Sum_35 (n)");
   Put_Line ("-----------------------------------------------------------------");
   for E in 0 .. 30 loop
      declare
         N : constant Natural := 10**E;
      begin
         Put (To_String (N, Width => 32));
         Put (" : ");
         Put (Sum_35 (N)'Image);
         New_Line;
      end;
   end loop;
end Sum_Multiples_Big;
