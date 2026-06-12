-- Decimal floating point number to binary (and vice versa)
-- J. Carter     2023 Apr
-- We'll presume the input is a string containing the image of the number in the appropriate base, and the output is the
-- image in the other base; using the language's conversion of numeric literals seems like cheating
-- Uses the PragmAda Reusable Components (https://github.com/jrcarter/PragmARC)

with Ada.Strings.Fixed;
with Ada.Text_IO;
with PragmARC.Unbounded_Numbers.Rationals;

procedure Dec_Bin_FP is
   use PragmARC.Unbounded_Numbers.Rationals; -- Avoid losing any precision in the inputs

   function To_Binary (Decimal : in String) return String is
      (Image (Value (Decimal), Base => 2) );

   function To_Decimal (Binary : in String) return String is
      (Image (Value ("2#" & Binary & '#') ) );

   Decimal : constant String := "23.34375";
   Binary  : constant String := "1011.11101";
   Pi      : constant String := "3.14159265358979323846264338327950288419716939937511";
begin -- Dec_Bin_FP
   Ada.Text_IO.Put_Line (Item => Decimal & ' ' & To_Binary (Decimal) );
   Ada.Text_IO.Put_Line (Item => Binary & ' ' & To_Decimal (Binary) );
   Ada.Text_IO.Put_Line (Item => Pi & ' ' & To_Binary (Pi) );
end Dec_Bin_FP;
