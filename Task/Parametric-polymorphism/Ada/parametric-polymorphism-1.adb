generic
   type Element_Type is private;
package Container is
   type Tree is tagged private;
   procedure Replace_All(The_Tree : in out Tree; New_Value : Element_Type);
private
   type Node;
   type Node_Access is access Node;
   type Tree tagged record
      Value : Element_type;
      Left  : Node_Access := null;
      Right : Node_Access := null;
   end record;
end Container;
