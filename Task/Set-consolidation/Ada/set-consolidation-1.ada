generic
   type Element is (<>);
   with function Image(E: Element) return String;
package Set_Cons is

   type Set is private;

   -- constructor and manipulation functions for type Set
   function "+"(E: Element) return Set;
   function "+"(Left, Right: Element) return Set;
   function "+"(Left: Set; Right: Element) return Set;
   function "-"(Left: Set; Right: Element) return Set;

   -- compare, unite or output a Set
   function Nonempty_Intersection(Left, Right: Set) return Boolean;
   function Union(Left, Right: Set) return Set;
   function Image(S: Set) return String;

   type Set_Vec is array(Positive range <>) of Set;

   -- output a Set_Vec
   function Image(V: Set_Vec) return String;

private
   type Set is array(Element) of Boolean;

end Set_Cons;
