   package body Bin_Trees.Traverse is
      task body Inorder_Task is
         procedure Inorder(Tree: Tree_Type) is
         begin
            if not Empty(Tree) and not Stop then
               Inorder(Tree.Left);
               if not Stop then
                  Process_Data(Item => Tree.Item);
               end if;
               if (not Stop) then
                  Inorder(Tree.Right);
               end if;
            end if;
         end Inorder;
         T: Tree_Type;
      begin
         accept Run(Tree: Tree_Type) do
            T := Tree;
         end Run;
         Inorder(T);
         Finish;
      end Inorder_Task;
   end Bin_Trees.Traverse;
