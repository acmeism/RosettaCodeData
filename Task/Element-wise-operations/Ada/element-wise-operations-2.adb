generic
   type Rows is (<>);
   type Cols is (<>);
   type Num is private;
package Matrix_Scalar is
   type Matrix is array(Rows, Cols) of Num;

   generic
      with function F(L, R: Num) return Num;
   function Func(Left: Matrix; Right: Num) return Matrix;

   generic
      with function Image(N: Num) return String;
   function Image(M: Matrix) return String;

end Matrix_Scalar;
