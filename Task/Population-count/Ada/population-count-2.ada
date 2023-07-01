package body Population_Count is

   function Pop_Count(N: Num) return Natural is
      use Interfaces;
      K5555:  constant Unsigned_64 := 16#5555555555555555#;
      K3333:  constant Unsigned_64 := 16#3333333333333333#;
      K0f0f:  constant Unsigned_64 := 16#0f0f0f0f0f0f0f0f#;
      K0101:  constant Unsigned_64 := 16#0101010101010101#;
      X: Unsigned_64 := N;
   begin
      X :=  X            - (Shift_Right(X, 1)   and k5555);
      X := (X and k3333) + (Shift_Right(X, 2)   and k3333);
      X := (X            +  (Shift_Right(X, 4)) and K0f0f);
      X := Shift_Right((x * k0101), 56);
      return Natural(X);
   end Pop_Count;

end Population_Count;
