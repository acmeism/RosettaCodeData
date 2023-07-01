with Approximation, Ada.Numerics.Elementary_Functions;

procedure Test_Approximations is
   package A is new Approximation(Float,
                                  Ada.Numerics.Elementary_Functions.Sqrt,
                                  Ada.Numerics.Elementary_Functions."**");
   use type A.Number;
   X1: A.Number := A.Approx(100.0, 1.1);
   Y1: A.Number := A.Approx( 50.0, 1.2);
   X2: A.Number := A.Approx(200.0, 2.2);
   Y2: A.Number := A.Approx(100.0, 2.3);

begin
   A.Put_Line("Distance:",
              ((X1-X2)**2 + (Y1 - Y2)**2)**0.5,
              Sigma_Fore => 1);
end Test_Approximations;
