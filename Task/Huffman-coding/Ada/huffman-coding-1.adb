with Ada.Containers.Indefinite_Ordered_Maps;
with Ada.Containers.Ordered_Maps;
with Ada.Finalization;
generic
   type Symbol_Type is private;
   with function "<" (Left, Right : Symbol_Type) return Boolean is <>;
   with procedure Put (Item : Symbol_Type);
   type Symbol_Sequence is array (Positive range <>) of Symbol_Type;
   type Frequency_Type is private;
   with function "+" (Left, Right : Frequency_Type) return Frequency_Type
     is <>;
   with function "<" (Left, Right : Frequency_Type) return Boolean is <>;
package Huffman is
   -- bits = booleans (true/false = 1/0)
   type Bit_Sequence is array (Positive range <>) of Boolean;
   Zero_Sequence : constant Bit_Sequence (1 .. 0) := (others => False);
   -- output the sequence
   procedure Put (Code : Bit_Sequence);

   -- type for freqency map
   package Frequency_Maps is new Ada.Containers.Ordered_Maps
     (Element_Type => Frequency_Type,
      Key_Type     => Symbol_Type);

   type Huffman_Tree is private;
   -- create a huffman tree from frequency map
   procedure Create_Tree
     (Tree        : out Huffman_Tree;
      Frequencies : Frequency_Maps.Map);
   -- encode a single symbol
   function Encode
     (Tree   : Huffman_Tree;
      Symbol : Symbol_Type)
      return   Bit_Sequence;
   -- encode a symbol sequence
   function Encode
     (Tree    : Huffman_Tree;
      Symbols : Symbol_Sequence)
      return    Bit_Sequence;
   -- decode a bit sequence
   function Decode
     (Tree : Huffman_Tree;
      Code : Bit_Sequence)
      return Symbol_Sequence;
   -- dump the encoding table
   procedure Dump_Encoding (Tree : Huffman_Tree);
private
   -- type for encoding map
   package Encoding_Maps is new Ada.Containers.Indefinite_Ordered_Maps
     (Element_Type => Bit_Sequence,
      Key_Type     => Symbol_Type);

   type Huffman_Node;
   type Node_Access is access Huffman_Node;
   -- a node is either internal (left_child/right_child used)
   -- or a leaf (left_child/right_child are null)
   type Huffman_Node is record
      Frequency   : Frequency_Type;
      Left_Child  : Node_Access := null;
      Right_Child : Node_Access := null;
      Symbol      : Symbol_Type;
   end record;
   -- create a leaf node
   function Create_Node
     (Symbol    : Symbol_Type;
      Frequency : Frequency_Type)
      return      Node_Access;
   -- create an internal node
   function Create_Node (Left, Right : Node_Access) return Node_Access;
   -- fill the encoding map
   procedure Fill
     (The_Node : Node_Access;
      Map      : in out Encoding_Maps.Map;
      Prefix   : Bit_Sequence);

   -- huffman tree has a tree and an encoding map
   type Huffman_Tree is new Ada.Finalization.Controlled with record
      Tree : Node_Access       := null;
      Map  : Encoding_Maps.Map := Encoding_Maps.Empty_Map;
   end record;
   -- free memory after finalization
   overriding procedure Finalize (Object : in out Huffman_Tree);
end Huffman;
