--  cistercian.adb

pragma Ada_2022;

package body Cistercian is

   subtype Digit_Range is Natural range 0 .. 9;

   Digit_Strokes : constant array (Digit_Range) of Stroke_Used_Array :=
     [0 => [others => False],
      1 => [Far => True, others => False],
      2 => [Near => True, others => False],
      3 => [Diag_From_Far => True, others => False],
      4 => [Diag_From_Near => True, others => False],
      5 => [Diag_From_Near => True, Far => True, others => False],
      6 => [Side => True, others => False],
      7 => [Far => True, Side => True, others => False],
      8 => [Near => True, Side => True, others => False],
      9 => [Far => True, Near => True, Side => True, others => False]];
   --  maps each digit to the corresponding strokes
   --  this makes it easy for us to assign strokes later

   function From (Value : Representable_Range) return Representation is
      --  converts Value to a Representation
      Result : Representation;

      --  obtain digits, then...

      Ones_Digit : constant Digit_Range := Value rem 10;
      Tens_Digit : constant Digit_Range := ((Value - Ones_Digit) / 10) rem 10;
      Hund_Digit : constant Digit_Range :=
        ((Value - (Tens_Digit * 10 + Ones_Digit)) / 100) rem 10;
      Thou_Digit : constant Digit_Range :=
        (Value - (Hund_Digit * 100 + Tens_Digit * 10 + Ones_Digit)) / 1000;

   begin

      --  assign strokes to corresponding quadrants

      Result (Ones) := Digit_Strokes (Ones_Digit);
      Result (Tens) := Digit_Strokes (Tens_Digit);
      Result (Hundreds) := Digit_Strokes (Hund_Digit);
      Result (Thousands) := Digit_Strokes (Thou_Digit);

      return Result;

   end From;

end Cistercian;
