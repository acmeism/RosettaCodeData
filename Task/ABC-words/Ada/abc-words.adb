with Ada.Text_Io;
with Ada.Strings.Fixed;

procedure Abc_Words is
   use Ada.Text_Io;

   function Is_Abc_Word (Word : String) return Boolean is
      use Ada.Strings.Fixed;
      Pos_A : constant Natural := Index (Word, "a");
      Pos_B : constant Natural := Index (Word, "b");
      Pos_C : constant Natural := Index (Word, "c");
   begin
      return
        Pos_B > Pos_A and Pos_C > Pos_B and
        Pos_A /= 0 and Pos_B /= 0 and Pos_C /= 0;
   end Is_Abc_Word;

   Filename : constant String := "unixdict.txt";
   File     : File_Type;
   Column   : Ada.Text_Io.Count := 0;
begin
   Open (File, In_File, Filename);
   while not End_Of_File (File) loop
      declare
         Word : constant String := Get_Line (File);
      begin
         if Is_Abc_Word (Word) then
            Set_Col (1 + Column);
            Column := (Column + 15) mod 120;
            Put (Word);
         end if;
      end;
   end loop;
   Close (File);
end Abc_Words;
