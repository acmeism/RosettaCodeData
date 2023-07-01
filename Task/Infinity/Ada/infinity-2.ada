with Ada.Text_IO; use Ada.Text_IO;

procedure Infinities is
   type Real is digits 5 range -10.0..10.0;

   function Sup return Real is
      Result : Real := Real'Last;
   begin
      return Real'Succ (Result);
   exception
      when Constraint_Error =>
         return Result;
   end Sup;

   function Inf return Real is
      Result : Real := Real'First;
   begin
      return Real'Pred (Result);
   exception
      when Constraint_Error =>
         return Result;
   end Inf;
begin
   Put_Line ("Supremum" & Real'Image (Sup));
   Put_Line ("Infimum " & Real'Image (Inf));
end Infinities;
