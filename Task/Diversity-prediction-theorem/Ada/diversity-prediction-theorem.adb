with Ada.Text_IO;
with Ada.Command_Line;

procedure Diversity_Prediction is

   type Real is new Float;
   type Real_Array is array (Positive range <>) of Real;

   package Real_IO is new Ada.Text_Io.Float_IO (Real);
   use Ada.Text_IO, Ada.Command_Line, Real_IO;

   function Mean (Data : Real_Array) return Real is
      Sum : Real := 0.0;
   begin
      for V of Data loop
         Sum := Sum + V;
      end loop;
      return Sum / Real (Data'Length);
   end Mean;

   function Variance (Reference : Real; Data : Real_Array) return Real is
      Res : Real_Array (Data'Range);
   begin
      for A in Data'Range loop
         Res (A) := (Reference - Data (A)) ** 2;
      end loop;
      return Mean (Res);
   end Variance;

   procedure Diversity (Truth : Real; Estimates : Real_Array)
   is
      Average       : constant Real := Mean (Estimates);
      Average_Error : constant Real := Variance (Truth, Estimates);
      Crowd_Error   : constant Real := (Truth - Average) ** 2;
      Diversity     : constant Real := Variance (Average, Estimates);
   begin
      Real_IO.Default_Exp := 0;
      Real_IO.Default_Aft := 5;
      Put ("average-error : "); Put (Average_Error);  New_Line;
      Put ("crowd-error   : "); Put (Crowd_Error);    New_Line;
      Put ("diversity     : "); Put (Diversity);      New_Line;
   end Diversity;

begin
   if Argument_Count <= 1 then
      Put_Line ("Usage: diversity_prediction <truth> <data_1> <data_2> ...");
      return;
   end if;

   declare
      Truth     : constant Real := Real'Value (Argument (1));
      Estimates : Real_Array (2 .. Argument_Count);
   begin
      for A in 2 .. Argument_Count loop
         Estimates (A) := Real'Value (Argument (A));
      end loop;

      Diversity (Truth, Estimates);
   end;
end Diversity_Prediction;
