with Ada.Text_IO;
with Huffman;
procedure Main is
   package Char_Natural_Huffman_Tree is new Huffman
     (Symbol_Type => Character,
      Put => Ada.Text_IO.Put,
      Symbol_Sequence => String,
      Frequency_Type => Natural);
   Tree         : Char_Natural_Huffman_Tree.Huffman_Tree;
   Frequencies  : Char_Natural_Huffman_Tree.Frequency_Maps.Map;
   Input_String : constant String :=
     "this is an example for huffman encoding";
begin
   -- build frequency map
   for I in Input_String'Range loop
      declare
         use Char_Natural_Huffman_Tree.Frequency_Maps;
         Position : constant Cursor := Frequencies.Find (Input_String (I));
      begin
         if Position = No_Element then
            Frequencies.Insert (Key => Input_String (I), New_Item => 1);
         else
            Frequencies.Replace_Element
              (Position => Position,
               New_Item => Element (Position) + 1);
         end if;
      end;
   end loop;

   -- create huffman tree
   Char_Natural_Huffman_Tree.Create_Tree
     (Tree        => Tree,
      Frequencies => Frequencies);

   -- dump encodings
   Char_Natural_Huffman_Tree.Dump_Encoding (Tree => Tree);

   -- encode example string
   declare
      Code : constant Char_Natural_Huffman_Tree.Bit_Sequence :=
        Char_Natural_Huffman_Tree.Encode
          (Tree    => Tree,
           Symbols => Input_String);
   begin
      Char_Natural_Huffman_Tree.Put (Code);
      Ada.Text_IO.Put_Line
        (Char_Natural_Huffman_Tree.Decode (Tree => Tree, Code => Code));
   end;
end Main;
