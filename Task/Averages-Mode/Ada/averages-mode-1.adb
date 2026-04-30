generic
   type Element_Type is private;
   type Element_Array is array (Positive range <>) of Element_Type;
package Mode is

   function Get_Mode (Set : Element_Array) return Element_Array;

end Mode;
