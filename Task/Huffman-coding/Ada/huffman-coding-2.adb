with Ada.Text_IO;
with Ada.Unchecked_Deallocation;
with Ada.Containers.Vectors;
package body Huffman is
   package Node_Vectors is new Ada.Containers.Vectors
     (Element_Type => Node_Access,
      Index_Type   => Positive);

   function "<" (Left, Right : Node_Access) return Boolean is
   begin
      -- compare frequency
      if Left.Frequency < Right.Frequency then
         return True;
      elsif Right.Frequency < Left.Frequency then
         return False;
      end if;
      -- same frequency, choose leaf node
      if Left.Left_Child = null and then Right.Left_Child /= null then
         return True;
      elsif Left.Left_Child /= null and then Right.Left_Child = null then
         return False;
      end if;
      -- same frequency, same node type (internal/leaf)
      if Left.Left_Child /= null then
         -- for internal nodes, compare left children, then right children
         if Left.Left_Child < Right.Left_Child then
            return True;
         elsif Right.Left_Child < Left.Left_Child then
            return False;
         else
            return Left.Right_Child < Right.Right_Child;
         end if;
      else
         -- for leaf nodes, compare symbol
         return Left.Symbol < Right.Symbol;
      end if;
   end "<";
   package Node_Vector_Sort is new Node_Vectors.Generic_Sorting;

   procedure Create_Tree
     (Tree        : out Huffman_Tree;
      Frequencies : Frequency_Maps.Map) is
      Node_Queue : Node_Vectors.Vector := Node_Vectors.Empty_Vector;
   begin
      -- insert all leafs into the queue
      declare
         use Frequency_Maps;
         Position : Cursor      := Frequencies.First;
         The_Node : Node_Access := null;
      begin
         while Position /= No_Element loop
            The_Node :=
              Create_Node
                (Symbol    => Key (Position),
                 Frequency => Element (Position));
            Node_Queue.Append (The_Node);
            Next (Position);
         end loop;
      end;
      -- sort by frequency (see "<")
      Node_Vector_Sort.Sort (Node_Queue);
      -- iterate over all elements
      while not Node_Queue.Is_Empty loop
         declare
            First : constant Node_Access := Node_Queue.First_Element;
         begin
            Node_Queue.Delete_First;
            -- if we only have one node left, it is the root node of the tree
            if Node_Queue.Is_Empty then
               Tree.Tree := First;
            else
               -- create new internal node with two smallest frequencies
               declare
                  Second : constant Node_Access := Node_Queue.First_Element;
               begin
                  Node_Queue.Delete_First;
                  Node_Queue.Append (Create_Node (First, Second));
               end;
               Node_Vector_Sort.Sort (Node_Queue);
            end if;
         end;
      end loop;
      -- fill encoding map
      Fill (The_Node => Tree.Tree, Map => Tree.Map, Prefix => Zero_Sequence);
   end Create_Tree;

   -- create leaf node
   function Create_Node
     (Symbol    : Symbol_Type;
      Frequency : Frequency_Type)
      return      Node_Access
   is
      Result : Node_Access := new Huffman_Node;
   begin
      Result.Frequency := Frequency;
      Result.Symbol    := Symbol;
      return Result;
   end Create_Node;

   -- create internal node
   function Create_Node (Left, Right : Node_Access) return Node_Access is
      Result : Node_Access := new Huffman_Node;
   begin
      Result.Frequency   := Left.Frequency + Right.Frequency;
      Result.Left_Child  := Left;
      Result.Right_Child := Right;
      return Result;
   end Create_Node;

   -- fill encoding map
   procedure Fill
     (The_Node : Node_Access;
      Map      : in out Encoding_Maps.Map;
      Prefix   : Bit_Sequence) is
   begin
      if The_Node.Left_Child /= null then
         -- append false (0) for left child
         Fill (The_Node.Left_Child, Map, Prefix & False);
         -- append true (1) for right child
         Fill (The_Node.Right_Child, Map, Prefix & True);
      else
         -- leaf node reached, prefix = code for symbol
         Map.Insert (The_Node.Symbol, Prefix);
      end if;
   end Fill;

   -- free memory after finalization
   overriding procedure Finalize (Object : in out Huffman_Tree) is
      procedure Free is new Ada.Unchecked_Deallocation
        (Name   => Node_Access,
         Object => Huffman_Node);
      -- recursively free all nodes
      procedure Recursive_Free (The_Node : in out Node_Access) is
      begin
         -- free node if it is a leaf
         if The_Node.Left_Child = null then
            Free (The_Node);
         else
            -- free left and right child if node is internal
            Recursive_Free (The_Node.Left_Child);
            Recursive_Free (The_Node.Right_Child);
            -- free node afterwards
            Free (The_Node);
         end if;
      end Recursive_Free;
   begin
      -- recursively free root node
      Recursive_Free (Object.Tree);
   end Finalize;

   -- encode single symbol
   function Encode
     (Tree   : Huffman_Tree;
      Symbol : Symbol_Type)
      return   Bit_Sequence
   is
   begin
      -- simply lookup in map
      return Tree.Map.Element (Symbol);
   end Encode;

   -- encode symbol sequence
   function Encode
     (Tree    : Huffman_Tree;
      Symbols : Symbol_Sequence)
      return    Bit_Sequence
   is
   begin
      -- only one element
      if Symbols'Length = 1 then
         -- see above
         return Encode (Tree, Symbols (Symbols'First));
      else
         -- encode first element, append result of recursive call
         return Encode (Tree, Symbols (Symbols'First)) &
         Encode (Tree, Symbols (Symbols'First + 1 .. Symbols'Last));
      end if;
   end Encode;

   -- decode a bit sequence
   function Decode
     (Tree : Huffman_Tree;
      Code : Bit_Sequence)
      return Symbol_Sequence
   is
      -- maximum length = code length
      Result   : Symbol_Sequence (1 .. Code'Length);
      -- last used index of result
      Last     : Natural     := 0;
      The_Node : Node_Access := Tree.Tree;
   begin
      -- iterate over the code
      for I in Code'Range loop
         -- if current element is true, descent the right branch
         if Code (I) then
            The_Node := The_Node.Right_Child;
         else
            -- false: descend left branch
            The_Node := The_Node.Left_Child;
         end if;
         if The_Node.Left_Child = null then
            -- reached leaf node: append symbol to result
            Last          := Last + 1;
            Result (Last) := The_Node.Symbol;
            -- reset current node to root
            The_Node := Tree.Tree;
         end if;
      end loop;
      -- return subset of result array
      return Result (1 .. Last);
   end Decode;

   -- output a bit sequence
   procedure Put (Code : Bit_Sequence) is
      package Int_IO is new Ada.Text_IO.Integer_IO (Integer);
   begin
      for I in Code'Range loop
         if Code (I) then
            -- true = 1
            Int_IO.Put (1, 0);
         else
            -- false = 0
            Int_IO.Put (0, 0);
         end if;
      end loop;
      Ada.Text_IO.New_Line;
   end Put;

   -- dump encoding map
   procedure Dump_Encoding (Tree : Huffman_Tree) is
      use type Encoding_Maps.Cursor;
      Position : Encoding_Maps.Cursor := Tree.Map.First;
   begin
      -- iterate map
      while Position /= Encoding_Maps.No_Element loop
         -- key
         Put (Encoding_Maps.Key (Position));
         Ada.Text_IO.Put (" = ");
         -- code
         Put (Encoding_Maps.Element (Position));
         Encoding_Maps.Next (Position);
      end loop;
   end Dump_Encoding;
end Huffman;
