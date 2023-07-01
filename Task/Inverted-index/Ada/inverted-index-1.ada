with Ada.Text_IO, Generic_Inverted_Index, Ada.Strings.Hash, Parse_Lines;
use Ada.Text_IO;

procedure Inverted_Index is

   type Process_Word is access procedure (Word: String);

   package Inv_Idx is new Generic_Inverted_Index
     (Source_Type => String,
      Item_Type   => String,
      Hash        => Ada.Strings.Hash);

   use Inv_Idx;

   procedure Output(Sources: Source_Vecs.Vector) is
      Any_Output: Boolean := False;

      procedure Print_Source(S: String) is
      begin
         if not Any_Output then -- this is the first source found
            Put("Found in the following files: ");
            Any_Output := True;
         else -- there has been at least one source before
            Put(", ");
         end if;
         Put(S);
      end Print_Source;

      procedure Print is new Inv_Idx.Iterate(Print_Source);

   begin
      Print(Sources);
      if not Any_Output then
         Put("I did not find this in any of the given files!");
      end if;
      New_Line(2);
   end Output;

   procedure Read_From_File(Table: in out Storage_Type;
                            Filename: String) is
      F: File_Type;

      procedure Enter_Word(S: String) is
      begin
         Table.Store(Source => Filename,  Item => S);
      end Enter_Word;

      procedure Store_Words is new
        Parse_Lines.Iterate_Words(Parse_Lines.Word_Pattern, Enter_Word);

   begin
      Open(File => F, Mode => In_File, Name => Filename);
       while not End_Of_File(F) loop
          Store_Words(Get_Line(F));
      end loop;
      Close(F);
   exception
      when others =>
         Put_Line("Something wrong with File '" & Filename & "'");
         Put_Line("I'll ignore this!");
   end Read_From_File;

   procedure Read_Files(Tab: out Storage_Type; Line: in String) is

      procedure Read_File(S: String) is
      begin
         Read_From_File(Tab, S);
      end Read_File;

      procedure Read_All is new
        Parse_Lines.Iterate_Words(Parse_Lines.Filename_Pattern, Read_File);

   begin
      Read_All(Line);
   end Read_Files;

   S: Storage_Type;
   Done: Boolean := False;

begin
   Put_Line("Enter Filenames:");
   Read_Files(S, Get_Line);
   New_Line;

   while not Done loop
      Put_Line("Enter one or more words to search for; <return> to finish:");
      declare
         Words: String := Get_Line;
         First: Boolean := True;
         Vec: Source_Vecs.Vector := Source_Vecs.Empty_Vector;

         procedure Compute_Vector(Item: String) is
         begin
            if First then
               Vec := S.Find(Item);
               First := False;
            else
               Vec := Vec and S.Find(Item);
            end if;
         end Compute_Vector;

         procedure Compute is new
           Parse_Lines.Iterate_Words(Parse_Lines.Word_Pattern, Compute_Vector);

      begin
         if Words = "" then
            Done := True;
         else
            Compute(Words);
            Output(Vec);
         end if;
      end;
   end loop;
end Inverted_Index;
