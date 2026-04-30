generic
   type Data is private;
package Bin_Trees is

   type Tree_Type is private;

   function Empty(Tree: Tree_Type) return Boolean;
   function Left (Tree: Tree_Type) return Tree_Type;
   function Right(Tree: Tree_Type) return Tree_Type;
   function Item (Tree: Tree_Type) return Data;
   function Empty return Tree_Type;

   procedure Destroy_Tree(N: in out Tree_Type);
   function Tree(Value: Data) return Tree_Type;
   function Tree(Value: Data; Left, Right : Tree_Type) return Tree_Type;

private

   type Node;
   type Tree_Type is access Node;
   type Node is record
      Left, Right: Tree_Type := null;
      Item: Data;
   end record;

end Bin_Trees;
