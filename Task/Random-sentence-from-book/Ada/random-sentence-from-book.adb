with Ada.Characters.Handling;
with Ada.Containers.Vectors;
with Ada.Containers.Ordered_Maps;
with Ada.Numerics.Discrete_Random;
with Ada.Strings.Fixed;
with Ada.Strings.Bounded;
with Ada.Text_IO;

procedure Random_Sentence_From_Book is
   Book_Filename : constant String := "war-of-the-worlds.txt";
   Start_Line : constant String := "*** START OF THE PROJECT GUTENBERG EBOOK";
   End_Line : constant String := "*** END OF THE PROJECT GUTENBERG EBOOK";

   procedure Open_Book (FN : String) is
      use Ada.Text_IO;
      F : File_Type;
   begin
      Open (F, In_File, FN);
      Set_Input (F);
   end Open_Book;

   procedure Close_Book is
      use Ada.Text_IO;
      Book : File_Type := Current_Input;
   begin
      Close (Book);
   end Close_Book;

   function Starts_With (Source, Pattern : String) return Boolean is
      (Pattern = Ada.Strings.Fixed.Head (Source, Pattern'Length));

   Started : Boolean := False;
   Ended : Boolean := False;
   function Read_Line return String is
      use Ada.Strings.Fixed;
      use Ada.Text_IO;
   begin
      while not Started loop
         declare
            Line : String := Get_Line;
         begin
            if Starts_With (Line, Start_Line) then
               Started := True;
            end if;
         end;
      end loop;

      declare
         Line : String := Get_Line;
         Empty : String (1 .. 0);
      begin
         if Starts_With (Line, End_Line) then
            Ended := True;
         end if;

         if Ended then
            return Empty;
         else
            return Line;
         end if;
      end;
   end Read_Line;

   Buffer : String (1 .. 128);
   Position : Positive := 1;
   Line_Length : Natural := 0;
   function Read_Buffered_Character return Character is
      C : Character;
   begin
      if Position > Line_Length then
         declare
            Line : String := Read_Line;
         begin
            Buffer (1 .. Line'Length) := Line;
            Position := 1;
            Line_Length := Line'Length;
         end;
      end if;

      C := Buffer (Position);
      Position := Position + 1;
      return C;
   end Read_Buffered_Character;

   function Is_Word_Letter (C : Character) return Boolean is
     (Ada.Characters.Handling.Is_Basic (C) or else Ada.Characters.Handling.Is_Digit (C));

   function Is_End_Punctuation (C : Character) return Boolean is
     (C = '.' or else C = '?' or else C = '!');

   function Keep_Character (C : Character) return Boolean is
     (Is_Word_Letter (C) or else Is_End_Punctuation (C));

   package Words is new Ada.Strings.Bounded.Generic_Bounded_Length (64);
   type Word_Type is (Punctuation, Letters);

   function Categorize (C : Character) return Word_Type is
     (if Is_Word_Letter (C) then Letters else Punctuation);

   function Read_Word return Words.Bounded_String is
      C : Character;
      W : Words.Bounded_String;
      T : Word_Type;
   begin
      loop
         C := Read_Buffered_Character;
         exit when Ended or else Keep_Character (C);
      end loop;

      T := Categorize (C);

      while Keep_Character (C) and then T = Categorize (C) loop
         Words.Append (W, C);
         C := Read_Buffered_Character;
      end loop;

      if Keep_Character (C) and then T /= Categorize (C) then
         Position := Position - 1;
      end if;

      return W;
   end Read_Word;

   package Word_Vectors is new Ada.Containers.Vectors
     (Positive, Words.Bounded_String, Words."=");

   package Word_Bags is new Ada.Containers.Ordered_Maps
     (Words.Bounded_String, Natural, Words."<", "=");

   type Terminal is record
      Total : Positive;
      Terminal_Words : Word_Bags.Map;
   end record;

   function "<" (V1, V2 : Word_Vectors.Vector) return Boolean is
      L1 : Natural := Natural (V1.Length);
      L2 : Natural := Natural (V2.Length);
      Min : Natural := Natural'Min (L1, L2);
   begin
      for I in 1 .. Min loop
         if Words."<" (V1.Element (I), V2.Element (I)) then
            return True;
         elsif Words."<" (V2.Element (I), V1.Element (I)) then
            return False;
         end if;
      end loop;

      if L1 < L2 then
         return True;
      else
         return False;
      end if;
   end "<";

   package Chain_Occurrences is new Ada.Containers.Ordered_Maps
     (Word_Vectors.Vector, Terminal, "<", "=");

   procedure Update
     (Chain_Occurrence : in out Chain_Occurrences.Map;
      Chain : Word_Vectors.Vector;
      Terminal_Word : Words.Bounded_String) is

      Position : Chain_Occurrences.Cursor;
      Inserted : Boolean;
      Bag : Word_Bags.Map;
      Term : Terminal;

      procedure Add_Word (K : Words.Bounded_String; V : in out Natural) is
      begin
         V := V + 1;
      end Add_Word;

      procedure Add_Chain (K : Word_Vectors.Vector; V : in out Terminal) is
         Position : Word_Bags.Cursor;
         Inserted : Boolean;
      begin
         V.Terminal_Words.Insert (Terminal_Word, 1, Position, Inserted);

         if not Inserted then
            V.Total := V.Total + 1;
            V.Terminal_Words.Update_Element (Position, Add_Word'Access);
         end if;
      end Add_Chain;
   begin
      Bag.Insert (Terminal_Word, 1);
      Term := (1, Bag);

      Chain_Occurrence.Insert (Chain, Term, Position, Inserted);

      if not Inserted then
         Chain_Occurrence.Update_Element (Position, Add_Chain'Access);
      end if;
   end Update;

   function Count_Chains return Chain_Occurrences.Map is
      use Word_Vectors;
      Chain, C1, C2 : Word_Vectors.Vector;
      E : Words.Bounded_String;
      Chain_Occurrence : Chain_Occurrences.Map;
   begin
      Open_Book (Book_Filename);

      Chain.Append (Read_Word);
      Chain.Append (Read_Word);
      Chain.Append (Read_Word);

      while not Ended loop
         C1 := Empty_Vector & Chain.Element (1);
         C2 := Empty_Vector & Chain.Element (1) & Chain.Element (2);
         Update (Chain_Occurrence, C1, Chain.Element (2));
         Update (Chain_Occurrence, C2, Chain.Element (3));
         Chain.Append (Read_Word);
         Chain.Delete_First;
      end loop;

      Close_Book;
      return Chain_Occurrence;
   end Count_Chains;

   package Random is new Ada.Numerics.Discrete_Random (Positive);
   Gen : Random.Generator;

   function Random_Terminal
     (Chain_Occurrence : Chain_Occurrences.Map; Chain : Word_Vectors.Vector)
     return Words.Bounded_String is
      Position : Chain_Occurrences.Cursor := Chain_Occurrence.Find (Chain);
      W : Words.Bounded_String;

      procedure Weighted_Random (K : Word_Vectors.Vector; V : Terminal) is
         T : Positive renames V.Total;
         Ws : Word_Bags.Map renames V.Terminal_Words;
         Rn : Positive := Random.Random (Gen, 1, T);
         Sum : Natural := 0;
      begin
         for Pos in Ws.Iterate loop
            Sum := Sum + Word_Bags.Element (Pos);
            if Rn <= Sum then
               W := Word_Bags.Key (Pos);
               return;
            end if;
         end loop;
      end Weighted_Random;
   begin
      Chain_Occurrences.Query_Element (Position, Weighted_Random'Access);
      return W;
   end Random_Terminal;

   procedure Generate_Sentences (Chain_Occurrence : Chain_Occurrences.Map; N : Natural) is
      use Ada.Text_IO;
      use Word_Vectors;
      Chain : Word_Vectors.Vector;
      Next : Words.Bounded_String;
   begin
      for I in 1 .. N loop
         Chain := To_Vector (Words.To_Bounded_String ("."), 1);
         Next := Random_Terminal (Chain_Occurrence, Chain);
         Chain.Append (Next);

         while not Is_End_Punctuation (Words.To_String (Next) (1)) loop
            Put (Words.To_String (Next) & " ");
            Next := Random_Terminal (Chain_Occurrence, Chain);
            Chain.Append (Next);
            Chain.Delete_First;
         end loop;

         Put_Line (ASCII.bs & Words.To_String (Next));
      end loop;
   end Generate_Sentences;

   Co : Chain_Occurrences.Map := Count_Chains;
begin
   Generate_Sentences (Co, 5);
end Random_Sentence_From_Book;
