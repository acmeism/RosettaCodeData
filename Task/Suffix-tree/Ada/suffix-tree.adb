with Ada.Text_IO;  use Ada.Text_IO;

with Generic_Directed_Weighted_Graph;
with Generic_Address_Order;

procedure Suffix_Tree is

   type Node_Type is null record;    -- Nodes have no contents
   type Default is access Node_Type; -- Default access type
   --
   -- Node_Order -- Ordering of nodes by their addresses
   --
   package Node_Order is new Generic_Address_Order (Node_Type);
   use Node_Order;
   --
   -- Ordering of the edge weights
   --
   function Equal (Left, Right : access String) return Boolean is
   begin
      return Left.all = Right.all;
   end Equal;
   function Less (Left, Right : access String) return Boolean is
   begin
      return Left.all < Right.all;
   end Less;
   --
   -- Directed graph of Node_Type weighted by Character values
   --
   package Character_Weighted_Graphs is
      new Generic_Directed_Weighted_Graph
          (  Node_Type            => Node_Type,
             Weight_Type          => String,
             Pool                 => Default'Storage_Pool,
             Minimal_Parents_Size => 1
          );
   use Character_Weighted_Graphs;
   subtype Suffix_Tree is Character_Weighted_Graphs.Node;
   --
   -- Print -- Outputs a tree
   --
   procedure Print (Tree : Suffix_Tree; Prefix : String := "") is
   begin
      for Index in 1..Get_Children_Number (Tree) loop
         Put_Line (Prefix & "|_" & Get_Weight (Tree, Index));
         if Index < Get_Children_Number (Tree) then
            Print (Get_Child (Tree, Index), Prefix & "| ");
         else
            Print (Get_Child (Tree, Index), Prefix & "  ");
         end if;
      end loop;
   end Print;
   --
   -- Join -- Merge consequtive signle descendant nodes
   --
   procedure Join (Parent : Node; Child : in out Node) is
      This : Node;
   begin
      for Index in 1..Get_Children_Number (Child) loop
         This := Get_Child (Child, Index);
         Join (Child, This);
      end loop;
      if Get_Children_Number (Child) = 1 then
         declare
            Weight : constant String := Get_Weight (Parent, Child) &
                                        Get_Weight (Child,  This);
         begin
            Delete (Child, Self);
            Connect (Parent, This, Weight);
            Child := This;
         end;
      end if;
   end Join;
   --
   -- Build -- Creates the suffix tree from a string
   --
   function Build (Text : String) return Suffix_Tree is
      Root  : Node := new Node_Type;
      Focus : Node;
      Lower : Natural;
      Upper : Natural;
   begin
      for Index in Text'Range loop
         Focus := Root;
         for Current in Index..Text'Last loop
            Classify (Focus, Text (Current..Current), Lower, Upper);
            if Lower = Upper then
               Focus := Get_Child (Focus, Lower);
            else
               declare
                  Branch : constant Node := new Node_Type;
               begin
                  Connect (Focus, Branch, Text (Current..Current));
                  Focus := Branch;
               end;
            end if;
         end loop;
      end loop;
      for Index in 1..Get_Children_Number (Root) loop
         Focus := Get_Child (Root, Index);
         Join (Root, Focus);
      end loop;
      return Root;
   end Build;

   Tree : Suffix_Tree := Build ("banana$");
begin
   Print (Tree);
   Delete (Tree);
end Suffix_Tree;
