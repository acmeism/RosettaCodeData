with Ada.Strings.Unbounded;

generic
   type Item_Type is private;
   with function To_String(Item: Item_Type) return String is <>;
   with procedure Put(S: String) is <>;
   with procedure Put_Line(Line: String) is <>;
package HTML_Table is

   subtype U_String is Ada.Strings.Unbounded.Unbounded_String;
   function Convert(S: String) return U_String renames
     Ada.Strings.Unbounded.To_Unbounded_String;

   type Item_Array is array(Positive range <>, Positive range <>) of Item_Type;
   type Header_Array is array(Positive range <>) of U_String;

   procedure Print(Items: Item_Array; Column_Heads: Header_Array);

end HTML_Table;
