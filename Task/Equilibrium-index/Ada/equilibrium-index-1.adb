with Ada.Containers.Vectors;

generic
   type Index_Type is range <>;
   type Element_Type is private;
   Zero : Element_Type;
   with function "+" (Left, Right : Element_Type) return Element_Type is <>;
   with function "-" (Left, Right : Element_Type) return Element_Type is <>;
   with function "=" (Left, Right : Element_Type) return Boolean is <>;
   type Array_Type is private;
   with function Element (From : Array_Type; Key : Index_Type) return Element_Type is <>;
package Equilibrium is
   package Index_Vectors is new Ada.Containers.Vectors
      (Index_Type => Positive, Element_Type => Index_Type);

   function Get_Indices (From : Array_Type) return Index_Vectors.Vector;

end Equilibrium;
