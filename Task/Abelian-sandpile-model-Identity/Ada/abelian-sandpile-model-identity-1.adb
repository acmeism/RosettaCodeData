-- Works with Ada 2012

package Abelian_Sandpile is
   Limit : constant Integer := 4;

   type Sandpile is array (0 .. 2, 0 .. 2) of Natural with
      Default_Component_Value => 0;

   procedure Stabalize (Pile : in out Sandpile);
   function Is_Stable (Pile : in Sandpile) return Boolean;
   procedure Topple (Pile : in out Sandpile);
   function "+" (Left, Right : Sandpile) return Sandpile;
   procedure Print(PIle : in Sandpile);

end Abelian_Sandpile;
