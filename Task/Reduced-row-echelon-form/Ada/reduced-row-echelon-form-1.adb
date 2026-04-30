generic
   type Element_Type is private;
   Zero : Element_Type;
   with function "-" (Left, Right : in Element_Type) return Element_Type is <>;
   with function "*" (Left, Right : in Element_Type) return Element_Type is <>;
   with function "/" (Left, Right : in Element_Type) return Element_Type is <>;
package Matrices is
   type Matrix is
     array (Positive range <>, Positive range <>) of Element_Type;
   function Reduced_Row_Echelon_form (Source : Matrix) return Matrix;
end Matrices;
