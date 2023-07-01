package body Thiele is
   use type Real_Array;

   function "/" (Left, Right : Real_Array) return Real_Array is
      Result : Real_Array (Left'Range);
   begin
      if Left'Length /= Right'Length then
         raise Constraint_Error with "arrays not same size";
      end if;
      for I in Result'Range loop
         Result (I) := Left (I) / Right (I);
      end loop;
      return Result;
   end "/";

   function Rho (X, Y : Real_Array) return Real_Array is
      N      : constant Natural                      := X'Length;
      P      : array (1 .. N) of Real_Array (1 .. N) :=
        (others => (others => 9.9));
      Result : Real_Array (1 .. N);
   begin
      P (1) (1 .. N)      := Y (1 .. N);
      P (2) (1 .. N - 1)  := (X (1 .. N - 1) - X (2 .. N)) /
        (P (1) (1 .. N - 1) - P (1) (2 .. N));
      for I in 3 .. N loop
         P (I) (1 .. N - I + 1)  := P (I - 2) (2 .. N - I + 2) +
           (X (1 .. N - I + 1) - X (I .. N)) /
           (P (I - 1) (1 .. N - I + 1) - P (I - 1) (2 .. N - I + 2));
      end loop;
      for I in X'Range loop
         Result (I) := P (I) (1);
      end loop;
      return Result;
   end Rho;

   function Create (X, Y : Real_Array) return Thiele_Interpolation is
   begin
      if X'Length < 3 then
         raise Constraint_Error with "at least 3 values";
      end if;
      if X'Length /= Y'Length then
         raise Constraint_Error with "input arrays not same size";
      end if;
      return (Length => X'Length, X => X, Y => Y, RhoX => Rho (X, Y));
   end Create;

   function Inverse (T : Thiele_Interpolation; X : Real) return Real is
      A : Real := 0.0;
   begin
      for I in reverse 3 .. T.Length loop
         A := (X - T.X (I - 1)) / (T.RhoX (I) - T.RhoX (I - 2) + A);
      end loop;
      return T.Y (1) + (X - T.X (1)) / (T.RhoX (2) + A);
   end Inverse;

end Thiele;
