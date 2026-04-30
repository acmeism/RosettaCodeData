with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Command_Line; use Ada.Command_Line;

procedure Rot_13 is

   From_Sequence : Character_Sequence := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
   Result_Sequence : Character_Sequence := "nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM";
   Rot_13_Mapping : Character_Mapping := To_Mapping(From_Sequence, Result_Sequence);

   In_Char : Character;
   Stdio : Stream_Access := Stream(Ada.Text_IO.Standard_Input);
   Stdout : Stream_Access := Stream(Ada.Text_Io.Standard_Output);
   Input : Ada.Text_Io.File_Type;

begin
   if Argument_Count > 0 then
      for I in 1..Argument_Count loop
         begin
            Ada.Text_Io.Open(File => Input, Mode => Ada.Text_Io.In_File, Name => Argument(I));
            Stdio := Stream(Input);
             while not Ada.Text_Io.End_Of_File(Input) loop
               In_Char :=Character'Input(Stdio);
               Character'Output(Stdout, Value(Rot_13_Mapping, In_Char));
            end loop;
            Ada.Text_IO.Close(Input);
         exception
            when Ada.Text_IO.Name_Error =>
               Ada.Text_Io.Put_Line(File => Ada.Text_Io.Standard_Error, Item => "File " & Argument(I) & " is not a file.");
            when Ada.Text_Io.Status_Error =>
               Ada.Text_Io.Put_Line(File => Ada.Text_Io.Standard_Error, Item => "File " & Argument(I) & " is already opened.");
         end;
      end loop;
   else
      while not Ada.Text_Io.End_Of_File loop
         In_Char :=Character'Input(Stdio);
         Character'Output(Stdout, Value(Rot_13_Mapping, In_Char));
      end loop;
   end if;
end Rot_13;
