with Ada.Text_IO;

procedure Factorions is
   subtype Factorial_Domain is Natural range 0 .. 11;
   subtype Log_Base is Positive range 2 .. Positive'Last;
   type Result_Table is array (Factorial_Domain) of Positive;

   Factorial    : Result_Table;
   Search_Limit : Positive := 1_500_000;

   procedure Precompute_Factorials is
   begin
      Factorial (0) := 1;

      for I in 1 .. Factorial'Last loop
         Factorial (I) := I * Factorial (I - 1);
      end loop;
   end Precompute_Factorials;

   function Floor_Log (Number : Positive; Base : Log_Base) return Natural is
      Remaining : Natural := Number;
      Floor_Log : Natural := 0;
   begin
      while Remaining > Base loop
         Remaining := Remaining / Base;
         Floor_Log := Floor_Log + 1;
      end loop;

      return Floor_Log;
   end Floor_Log;

   function Digit (Number, Index : Natural; Base : Log_Base) return Natural is
   begin
      return (Number / (Base ** Index)) mod Base;
   end Digit;

   function Is_Factorion (Number : Positive; Base : Log_Base) return Boolean is
      Digit_Sum : Natural := 0;
   begin
      for I in 0 .. Floor_Log (Number, Base) loop
         Digit_Sum := Digit_Sum + Factorial (Digit (Number, I, Base));
      end loop;

      return Digit_Sum = Number;
   end Is_Factorion;

   procedure Show_Factorions (Base : Log_Base) is
   begin
      Ada.Text_IO.Put_Line ("Search Base " & Base'Image);
      for I in 1 .. Search_Limit loop
         if Is_Factorion (I, Base) then
            Ada.Text_IO.Put_Line (I'Image);
         end if;
      end loop;
      Ada.Text_IO.Put_Line ("Done Base " & Base'Image);
   end Show_Factorions;

begin
   Precompute_Factorials;
   Show_Factorions (9);
   Show_Factorions (10);
   Show_Factorions (11);
   Show_Factorions (12);
end Factorions;
