with Ada.Sequential_IO;

procedure Read_And_Write_File_Character_By_Character is
   package Char_IO is new Ada.Sequential_IO (Character);
   use Char_IO;

   Input, Output : File_Type;
   Buffer        : Character;
begin
   Open   (File => Input,  Mode => In_File,  Name => "input.txt");
   Create (File => Output, Mode => Out_File, Name => "output.txt");
   loop
      Read  (File => Input,  Item => Buffer);
      Write (File => Output, Item => Buffer);
   end loop;
   Close (Input);
   Close (Output);
exception
   when End_Error =>
      if Is_Open(Input) then
         Close (Input);
      end if;
      if Is_Open(Output) then
         Close (Output);
      end if;
end Read_And_Write_File_Character_By_Character;
