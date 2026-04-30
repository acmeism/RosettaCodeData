with Ada.Text_IO;

procedure Apply_Filter is

   generic
      type Num is digits <>;
      type Num_Array is array (Natural range <>) of Num;
      A : Num_Array;
      B : Num_Array;
   package Direct_Form_II_Transposed is
      pragma Assert (A'First = 0 and B'First = 0);
      pragma Assert (A'Last = B'Last);
      pragma Assert (A (0) = 1.000);

      function Filter (X : in Num) return Num;
   end Direct_Form_II_Transposed;

   package body Direct_Form_II_Transposed
   is
      W : Num_Array (A'Range) := (others => 0.0);

      function Filter (X : in Num) return Num is
         Y : constant Num := X * B (0) + W (0);
      begin
         --  Calculate delay line for next sample
         for I in 1 .. W'Last loop
            W (I - 1) := X * B (I) - Y * A (I) + W (I);
         end loop;
         return Y;
      end Filter;

   end Direct_Form_II_Transposed;

   type Coeff_Array is array (Natural range <>) of Float;

   package Butterworth is
      new Direct_Form_II_Transposed (Float, Coeff_Array,
                                     A => (1.000000000000, -2.77555756e-16,
                                           3.33333333e-01, -1.85037171e-17),
                                     B => (0.16666667, 0.50000000,
                                           0.50000000, 0.16666667));

   subtype Signal_Array is Coeff_Array;

   X_Signal : constant Signal_Array :=
     (-0.917843918645, 0.141984778794, 1.20536903482, 0.190286794412, -0.662370894973,
      -1.00700480494, -0.404707073677, 0.800482325044, 0.743500089861, 1.01090520172,
      0.741527555207,  0.277841675195, 0.400833448236, -0.2085993586, -0.172842103641,
      -0.134316096293, 0.0259303398477, 0.490105989562, 0.549391221511, 0.9047198589);

   package Float_IO is
      new Ada.Text_IO.Float_IO (Float);
   Y : Float;
begin
   for Sample of X_Signal loop
      Y := Butterworth.Filter (Sample);
      Float_IO.Put (Y, Exp => 0, Aft => 6);
      Ada.Text_IO.New_Line;
   end loop;
end Apply_Filter;
