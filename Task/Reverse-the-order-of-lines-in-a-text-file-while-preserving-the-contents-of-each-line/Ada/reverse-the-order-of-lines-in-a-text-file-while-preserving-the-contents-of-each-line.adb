with Ada.Text_Io;
with Ada.Containers.Indefinite_Vectors;
with Ada.Command_Line;

procedure Reverse_Lines_In_File is

   subtype Line_Number is Natural;

   package Line_Vectors
   is new Ada.Containers.Indefinite_Vectors
     (Index_Type   => Line_Number,
      Element_Type => String);

   use Line_Vectors,
     Ada.Text_Io,
     Ada.Command_Line;

   File   : File_Type;
   Buffer : Vector;
begin
   if Argument_Count = 1 then
      Open (File, In_File, Argument (1));
      Set_Input (File);
   end if;

   while not End_Of_File loop
      Buffer.Prepend (Get_Line);
   end loop;

   if Is_Open (File) then
      Close (File);
   end if;

   for Line of Buffer loop
      Put_Line (Line);
   end loop;

end Reverse_Lines_In_File;
