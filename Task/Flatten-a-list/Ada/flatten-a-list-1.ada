generic
   type Element_Type is private;
   with function To_String (E : Element_Type) return String is <>;
package Nestable_Lists is

   type Node_Kind is (Data_Node, List_Node);

   type Node (Kind : Node_Kind);

   type List is access Node;

   type Node (Kind : Node_Kind) is record
      Next : List;
      case Kind is
         when Data_Node =>
            Data    : Element_Type;
         when List_Node =>
            Sublist : List;
      end case;
   end record;

   procedure Append (L : in out List; E : Element_Type);
   procedure Append (L : in out List; N : List);

   function Flatten (L : List) return List;

   function New_List (E : Element_Type) return List;
   function New_List (N : List) return List;

   function To_String (L : List) return String;

end Nestable_Lists;
