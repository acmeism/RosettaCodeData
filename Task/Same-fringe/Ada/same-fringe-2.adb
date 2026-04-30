with Ada.Unchecked_Deallocation;

package body Bin_Trees is

   function Empty(Tree: Tree_Type) return Boolean is
   begin
      return Tree = null;
   end Empty;

   function Empty return Tree_Type is
   begin
      return null;
   end Empty;

   function Left (Tree: Tree_Type) return Tree_Type is
   begin
      return Tree.Left;
   end Left;

   function Right(Tree: Tree_Type) return Tree_Type is
   begin
      return Tree.Right;
   end Right;

   function Item (Tree: Tree_Type) return Data is
   begin
      return Tree.Item;
   end Item;

   procedure Destroy_Tree(N: in out Tree_Type) is
      procedure free is new Ada.Unchecked_Deallocation(Node, Tree_Type);
   begin
      if not Empty(N) then
         Destroy_Tree(N.Left);
         Destroy_Tree(N.Right);
         Free(N);
      end if;
   end Destroy_Tree;

   function Tree(Value: Data; Left, Right : Tree_Type) return Tree_Type is
      Temp : Tree_Type := new Node;
   begin
      Temp.all := (Left, Right, Value);
      return Temp;
   end Tree;

   function Tree(Value: Data) return Tree_Type is
   begin
      return Tree(Value, null, null);
   end Tree;

end Bin_Trees;
