package Apollonius is
   type Point is record
      X, Y : Long_Float := 0.0;
   end record;

   type Circle is record
      Center : Point;
      Radius : Long_Float := 0.0;
   end record;

   type Tangentiality is (External, Internal);

   function Solve_CCC
     (Circle_1, Circle_2, Circle_3 : Circle;
      T1, T2, T3                   : Tangentiality := External)
      return                         Circle;
end Apollonius;
