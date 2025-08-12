with Ada.Text_IO;

procedure Calkin_Wilf is
   type Rational is
      record
         Numerator : Integer;
         Denominator : Positive;
      end record;

   -- A generic solution would use Ada.Containers.Vectors, but
   -- these puzzles are written to avoid numbers larger than
   -- what fit in 64 bits, so we can assume a limit of 64 terms
   type Term_Array is array (1 .. 64) of Positive;

   type Continued_Fraction is
      record
         Count : Positive;
         Terms : Term_Array;
      end record;

   -- Don't bother with reducing or negatives
   function "+" (A, B : Rational) return Rational is
      (A.Numerator * B.Denominator + B.Numerator * A.Denominator,
         A.Denominator * B.Denominator);

   function "-" (A : Rational) return Rational is
      (-A.Numerator, A.Denominator);

   function "-" (A, B : Rational) return Rational is
     (A + (-B));

   function "*" (A, B : Rational) return Rational is
      (A.Numerator * B.Numerator,
         A.Denominator * B.Denominator);

   function Invert (A : Rational) return Rational is
      (A.Denominator,
         A.Numerator);

   function Floor (A : Rational) return Rational is
      (A.Numerator / A.Denominator,
         1);

   function Image (A : Rational) return String is
     (A.Numerator'Image & " /" & A.Denominator'Image);

   function "=" (A, B : Rational) return Boolean is
     (A.Numerator = B.Numerator and A.Denominator = B.Denominator);

   function Next_Calkin_Wilf_Term (R : Rational) return Rational is
      (Invert ((2, 1) * Floor (R) + (1, 1) - R));

   procedure Put_First_Terms (N : Positive) is
      R : Rational := (1, 1);
   begin
      Ada.Text_IO.Put_Line (
        "The first " & N'Image & " terms of the Calkin-Wilf Sequence are:");
      for I in 1 .. N loop
         Ada.Text_IO.Put_Line (I'Image & ": " & Image (R));
         R := Next_Calkin_Wilf_Term (R);
      end loop;
   end Put_First_Terms;

   function To_Continued_Fraction (R : Rational) return Continued_Fraction is
      Count : Natural := 0;
      Terms : Term_Array;
      N : Natural := R.Numerator;
      D : Natural := R.Denominator;
      M : Natural;
   begin
      while D > 0 loop
         Count := Count + 1;
         Terms (Count) := N / D;
         M := N mod D;
         N := D;
         D := M;
      end loop;

      if Count mod 2 = 0 then
         Terms (Count .. Count + 1) := (Terms (Count) - 1, 1);
         Count := Count + 1;
      end if;

      return (Count, Terms);
   end To_Continued_Fraction;

   function To_Index (R : Rational) return Natural is
      Cont_Frac : Continued_Fraction := To_Continued_Fraction (R);
      Terms : Term_Array renames Cont_Frac.Terms;
      Index : Natural := 0;
   begin
      for I in reverse 1 .. Cont_Frac.Count loop
         for J in 1 .. Terms (I) loop
            Index := Index * 2 + (I mod 2);
         end loop;
      end loop;

      return Index;
   end To_Index;

   procedure Put_Term_Index (R : Rational) is
      Index : Natural := To_Index (R);
   begin
      Ada.Text_IO.Put_Line ("Term " & Image (R) & " is at index " & Index'Image);
   end Put_Term_Index;

begin
   Put_First_Terms (20);
   Put_Term_Index((83116, 51639));
end Calkin_Wilf;
