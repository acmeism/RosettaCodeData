with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;

procedure Using_Text_Streams is
   Input, Output : File_Type;
   Buffer        : Character;
begin
   Open   (File => Input,  Mode => In_File,  Name => "input.txt");
   Create (File => Output, Mode => Out_File, Name => "output.txt");
   loop
      Buffer := Character'Input (Stream (Input));
      Character'Write (Stream (Output), Buffer);
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
end Using_Text_Streams;
