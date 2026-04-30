   generic
      with procedure Process_Data(Item: Data);
      with function Stop return Boolean;
      with procedure Finish;
   package Bin_Trees.Traverse is
      task Inorder_Task is
         entry Run(Tree: Tree_Type);
         -- this will call each Item in Tree and, at the very end, it will call Finish
         -- except when Stop becomes true; in this case, the task terminates
      end Inorder_Task;
   end Bin_Trees.Traverse;
