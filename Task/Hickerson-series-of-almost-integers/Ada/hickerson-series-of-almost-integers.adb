with Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;

procedure Almost_Integers is

   type Real is new Long_Long_Float;

   package Real_IO is
      new Ada.Text_IO.Float_IO (Real);
   package Integer_IO is
      new Ada.Text_IO.Integer_IO (Integer);

   function Faculty (N : in Long_Long_Integer) return Long_Long_Integer is
      (if N < 2 then N else N * Faculty (N - 1));

   function Hickerson (N : in Integer) return Real
   is
      package Math is
         new Ada.Numerics.Generic_Elementary_Functions (Real);
      LN2         : constant Real := Math.Log (2.0, Base => Ada.Numerics.E);
      Numerator   : constant Real := Real (Faculty (Long_Long_Integer (N)));
      Denominator : constant Real := 2.0 * LN2 ** (N + 1);
   begin
      return Numerator / Denominator;
   end Hickerson;

   function Is_Almost_Integer (N : Real) return Boolean is
      Image : String (1 .. 100);
   begin
      Real_IO.Put (Image, N, Exp => 0, Aft => 2);

      pragma Assert (Image (Image'Last - 2) = '.');
      case Image (Image'Last - 1) is
         when '0' | '9' =>  return True;
         when others    =>  return False;
      end case;
   end Is_Almost_Integer;

   use Ada.Text_IO;
   Placeholder : String := " n                         h(n)  almost";
   Image_N : String renames Placeholder ( 1 ..  2);
   Image_H : String renames Placeholder ( 4 .. 31);
   Image_A : String renames Placeholder (34 .. 39);
begin
   Put_Line (Placeholder);
   Image_N := (others => '-');
   Image_H := (others => '-');
   Image_A := (others => '-');
   Put_Line (Placeholder);

   for N in 1 .. 17 loop
      declare
         H : constant Real    := Hickerson (N);
         I : constant Boolean := Is_Almost_Integer (H);
      begin
         Integer_IO.Put (Image_N, N);
         Real_IO.Put (Image_H, H, Exp => 0, Aft => 4);
         Image_A := (if I then "TRUE " else "FALSE");
         Put_Line (Placeholder);
      end;
   end loop;
end Almost_Integers;
