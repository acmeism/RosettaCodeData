generic
   type Element_Type is private;
package Brent is
   type Brent_Function is access function (X : Element_Type) return Element_Type;
   procedure Brent(F : Brent_Function; X0 : Element_Type; Lambda : out Integer; Mu : out Integer);
end Brent;
