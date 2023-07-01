package body Integrate is
   function Left_Rectangular (A, B : Scalar; N : Positive) return Scalar is
      H   : constant Scalar := (B - A) / Scalar (N);
      Sum : Scalar := 0.0;
      X   : Scalar;
   begin
      for I in 0 .. N - 1 loop
         X := A + Scalar (I) * H;
         Sum := Sum + H * F (X);
      end loop;
      return Sum;
   end Left_Rectangular;

   function Right_Rectangular (A, B : Scalar; N : Positive) return Scalar is
      H   : constant Scalar := (B - A) / Scalar (N);
      Sum : Scalar := 0.0;
      X   : Scalar;
   begin
      for I in 1 .. N loop
         X := A + Scalar (I) * H;
         Sum := Sum + H * F (X);
      end loop;
      return Sum;
   end Right_Rectangular;

   function Midpoint_Rectangular (A, B : Scalar; N : Positive) return Scalar is
      H   : constant Scalar := (B - A) / Scalar (N);
      Sum : Scalar := 0.0;
      X   : Scalar;
   begin
      for I in 1 .. N loop
         X := A + Scalar (I) * H - 0.5 * H;
         Sum := Sum + H * F (X);
      end loop;
      return Sum;
   end Midpoint_Rectangular;

   function Trapezium (A, B : Scalar; N : Positive) return Scalar is
      H   : constant Scalar := (B - A) / Scalar (N);
      Sum : Scalar := F(A) + F(B);
      X   : Scalar := 1.0;
   begin
      while X <= Scalar (N) - 1.0 loop
         Sum := Sum + 2.0 * F (A + X * (B - A) / Scalar (N));
         X := X + 1.0;
      end loop;
      return (B - A) / (2.0 * Scalar (N)) * Sum;
   end Trapezium;

   function Simpsons (A, B : Scalar; N : Positive) return Scalar is
      H     : constant Scalar := (B - A) / Scalar (N);
      Sum_U : Scalar := 0.0;
      Sum_E : Scalar := 0.0;
   begin
      for I in 1 .. N - 1 loop
         if I mod 2 /= 0 then
            Sum_U := Sum_U + F (A + H * Scalar (I));
         else
            Sum_E := Sum_E + F (A + H * Scalar (I));
         end if;
      end loop;
      return (H / 3.0) * (F (A) + F (B) + 4.0 * Sum_U + 2.0 * Sum_E);
   end Simpsons;
end Integrate;
