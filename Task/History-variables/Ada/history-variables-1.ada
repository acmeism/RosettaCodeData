private with Ada.Containers.Indefinite_Vectors;
generic
   type Item_Type (<>) is private;
package History_Variables is

   type Variable is tagged limited private;

   -- set and get current value
   procedure Set(V: in out Variable; Item: Item_Type);
   function Get(V: Variable) return Item_Type;

   -- number of items in history (including the current one)
   function Defined(V: Variable) return Natural;

   -- non-destructively search for old values
   function Peek(V: Variable; Generation: Natural := 1) return Item_Type;
   -- V.Peek(0) returns current value; V.Peek(1) the previous value, etc.
   -- when calling V.Peek(i), i must be in 0 .. V.Defined-1, else Constraint_Error is raised

   -- destructively restore previous value
   procedure Undo(V: in out Variable);
   -- old V.Peek(0) is forgotten, old V.Peek(i) is new V.Peek(i-1), etc.
   -- accordingly, V.Defined decrements by 1
   -- special case: if V.Defined=0 then V.Undo does not change V

private
   package Vectors is new Ada.Containers.Indefinite_Vectors
     (Index_Type   => Positive,
      Element_Type => Item_Type);

   type Variable is tagged limited record
      History: Vectors.Vector;
   end record;
end History_Variables;
