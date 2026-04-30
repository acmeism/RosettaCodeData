WITH GMP.Rationals, GMP.Integers, Ada.Text_IO, Ada.Strings.Fixed, Ada.Strings;
USE GMP.Rationals, GMP.Integers, Ada.Text_IO, Ada.Strings.Fixed, Ada.Strings;

PROCEDURE Main IS

   FUNCTION Bernoulli_Number (N : Natural) RETURN Unbounded_Fraction IS
      FUNCTION "/" (Left, Right : Natural) RETURN Unbounded_Fraction IS
        (To_Unbounded_Integer (Left) / To_Unbounded_Integer (Right));
      A : ARRAY (0 .. N) OF Unbounded_Fraction;
   BEGIN
      FOR M IN 0 .. N LOOP
         A (M) := 1 / (M + 1);
         FOR J IN REVERSE 1 .. M LOOP
            A (J - 1) := (J / 1 ) * (A (J - 1) - A (J));
         END LOOP;
      END LOOP;
      RETURN A (0);
   END Bernoulli_Number;

BEGIN
   FOR I IN 0 .. 60 LOOP
      IF I MOD 2 = 0 OR I = 1 THEN
         DECLARE
            B : Unbounded_Fraction := Bernoulli_Number (I);
            S : String := Image (GMP.Rationals.Numerator (B));
         BEGIN
            Put_Line ("B (" & (IF I < 10 THEN " " ELSE "") &  Trim (I'Img, Left)
                      & ")=" & (44 - S'Length) * " " & Image (B));
         END;
      END IF;
   END LOOP;
END Main;
