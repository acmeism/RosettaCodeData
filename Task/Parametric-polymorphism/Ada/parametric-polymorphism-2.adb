package body Container is
   procedure Replace_All(The_Tree : in out Tree; New_Value : Element_Type) is
   begin
      The_Tree.Value := New_Value;
      If The_Tree.Left /= null then
         The_Tree.Left.all.Replace_All(New_Value);
      end if;
      if The_tree.Right /= null then
         The_Tree.Right.all.Replace_All(New_Value);
      end if;
   end Replace_All;
end Container;
