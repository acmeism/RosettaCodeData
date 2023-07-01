generic
   type Element_Type is private;
   Zero : Element_Type;
   One : Element_Type;
   with function "+" (Left, Right : Element_Type) return Element_Type is <>;
   with function "-" (Left, Right : Element_Type) return Element_Type is <>;
   with function "*" (Left, Right : Element_Type) return Element_Type is <>;
   with function "/" (Left, Right : Element_Type) return Element_Type is <>;
package Matrices is
   type Vector is array (Positive range <>) of Element_Type;
   type Matrix is
     array (Positive range <>, Positive range <>) of Element_Type;

   function "*" (Left, Right : Matrix) return Matrix;
   function Invert (Source : Matrix) return Matrix;
   function Reduced_Row_Echelon_Form (Source : Matrix) return Matrix;
   function Regression_Coefficients
     (Source     : Vector;
      Regressors : Matrix)
      return       Vector;
   function To_Column_Vector
     (Source : Matrix;
      Row    : Positive := 1)
      return   Vector;
   function To_Matrix
     (Source        : Vector;
      Column_Vector : Boolean := True)
      return          Matrix;
   function To_Row_Vector
     (Source : Matrix;
      Column : Positive := 1)
      return   Vector;
   function Transpose (Source : Matrix) return Matrix;

   Size_Mismatch     : exception;
   Not_Square_Matrix : exception;
   Not_Invertible    : exception;
end Matrices;
