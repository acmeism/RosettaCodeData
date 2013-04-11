generic
   type Scalar is digits <>;
   with function F (X : Scalar) return Scalar;
package Integrate is
   function Left_Rectangular     (A, B : Scalar; N : Positive) return Scalar;
   function Right_Rectangular    (A, B : Scalar; N : Positive) return Scalar;
   function Midpoint_Rectangular (A, B : Scalar; N : Positive) return Scalar;
   function Trapezium            (A, B : Scalar; N : Positive) return Scalar;
   function Simpsons             (A, B : Scalar; N : Positive) return Scalar;
end Integrate;
