pragma Ada_2022;
with Ada.Containers.Multiway_Trees;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
procedure Word_Ladder is

   DICT_FILENAME : constant String   := "unixdict.txt";
   MAX_DEPTH     : constant Positive := 50;

   subtype LC_Chars is Character range 'a' .. 'z';

   type Word_Node_T is record
      Level : Positive;
      Word  : Unbounded_String;
   end record;

   package Word_Vectors is new Ada.Containers.Vectors (Positive, Unbounded_String);
   package Dict_Vectors is new Ada.Containers.Vectors (Positive, Unbounded_String);

   package Word_Trees is new Ada.Containers.Multiway_Trees (Word_Node_T);
   use Word_Trees;
   Word_Tree  : Tree;
   Solved     : Boolean;
   Solution   : Cursor;

   function Load_Candidate_Words (Dict_Filename : String; Word_Len : Positive)
            return Dict_Vectors.Vector is
      Dict_File : File_Type;
      Read_Word : Unbounded_String;
      Cands     : Dict_Vectors.Vector;
      Valid     : Boolean;
      C         : Character;
   begin
      Open (File => Dict_File, Mode => In_File, Name => Dict_Filename);
      while not End_Of_File (Dict_File) loop
         Read_Word := Get_Line (Dict_File);
         if Length (Read_Word) = Word_Len then
            Valid := True;
            for Ix in 1 .. Word_Len loop
               C := Element (Read_Word, Ix);
               Valid := C in LC_Chars;
               exit when not Valid;
            end loop;
            if Valid then Cands.Append (Read_Word); end if;
         end if;
      end loop;
      Close (Dict_File);
      return Cands;
   end Load_Candidate_Words;

   function Mutate (Word : Unbounded_String; Dict : in out Dict_Vectors.Vector)
            return Word_Vectors.Vector is
      Mutations : Word_Vectors.Vector;
      Poss_Word : Unbounded_String;
   begin
      for Ix in 1 .. Length (Word) loop
         for Letter in LC_Chars loop
            if Letter /= Element (Word, Ix) then
               Poss_Word := Word;
               Replace_Element (Poss_Word, Ix, Letter);
               if Dict.Contains (Poss_Word) then
                  Mutations.Append (Poss_Word);
                  Dict.Delete (Dict.Find_Index (Poss_Word));
               end if;
            end if;
         end loop;
      end loop;
      return Mutations;
   end Mutate;

   procedure Recurse_Tree (Start_Pos : Cursor;
                           Level     : Positive;
                           Target    : Unbounded_String;
                           Dict      : in out Dict_Vectors.Vector) is
      Pos        : Cursor := Start_Pos;
      Mutations  : Word_Vectors.Vector;
      New_Node   : Word_Node_T;
   begin
      while not Solved and then Pos /= No_Element loop
         if Element (Pos).Level = Level then
            Mutations := Mutate (Element (Pos).Word, Dict);
            if not Word_Vectors.Is_Empty (Mutations) then
               for Word of Mutations loop
                  New_Node.Level := Level + 1;
                  New_Node.Word  := Word;
                  Append_Child (Word_Tree, Pos, New_Node);
                  if Word = Target then
                     Solved := True;
                     Solution := Pos;
                  end if;
               end loop;
            end if;
         end if;
         if not Solved then
            Recurse_Tree (First_Child (Pos), Level, Target, Dict);
         end if;
         Pos := Next_Sibling (Pos);
      end loop;
   end Recurse_Tree;

   procedure Ladder (Start_S, Target_S : String) is
      Dictionary    : Dict_Vectors.Vector;
      Level         : Positive := 1;
      Word_Node     : Word_Node_T;
      Start, Target : Unbounded_String;
      Start_Pos     : Cursor;
      Output        : Unbounded_String;
   begin
      if Start_S'Length /= Target_S'Length then
         Put_Line ("ERROR: Start and Target words must be same length.");
         return;
      end if;
      Dictionary := Load_Candidate_Words (DICT_FILENAME, Start_S'Length);
      Start      := To_Unbounded_String (Start_S);
      Target     := To_Unbounded_String (Target_S);
      Solved     := False;
      Word_Node.Level := 1;
      Word_Node.Word  := Start;
      Word_Tree := Empty_Tree;
      Word_Tree.Insert_Child (Word_Tree.Root, No_Element, Word_Node);
      Start_Pos := Find (Word_Tree, Word_Node);
      while Level <= MAX_DEPTH and then not Solved loop
         Recurse_Tree (Start_Pos, Level, Target, Dictionary);
         Level := @ + 1;
      end loop;
      if not Solved then
         Put_Line (Start & " -> " & Target & " - No solution found at depth" & MAX_DEPTH'Image);
      else
         while not Is_Root (Solution) loop
            Word_Node := Element (Solution);
            Output := Word_Node.Word & " -> " & Output;
            Solution := Parent (Solution);
         end loop;
         Put_Line (Output & Target);
      end if;
   end Ladder;
begin
   Ladder ("boy", "man");
   Ladder ("girl", "lady");
   Ladder ("jane", "john");
   Ladder ("child", "adult");
   Ladder ("ada", "god");
   Ladder ("rust", "hell");
end Word_Ladder;
