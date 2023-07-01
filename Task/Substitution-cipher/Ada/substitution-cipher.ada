with Ada.Command_Line; use Ada.Command_Line;
with Ada.Sequential_IO;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Text_IO;

procedure Cipher is
   package Char_IO is new Ada.Sequential_IO (Character);
   use Char_IO;
   Alphabet: constant String := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
   Key :     constant String := "VsciBjedgrzyHalvXZKtUPumGfIwJxqOCFRApnDhQWobLkESYMTN";
   My_Map : Character_Mapping;
   Input, Output : File_Type;
   Buffer        : Character;
begin
   declare
      use Ada.Text_IO;
   begin
      if Argument_Count /= 1 then
	 Put_Line("Usage: " & Command_Name & " <encode|decode>");
      else
	 if Argument(1) = "encode" then
	    My_Map := To_Mapping(From => Alphabet, To => Key);
	 elsif Argument(1) = "decode" then
	    My_Map := To_Mapping(From => Key, To => Alphabet);
	 else
	    Put_Line("Unrecognised Argument: " & Argument(1));
	    return;
	 end if;
      end if;
   end;
   Open       (File => Input,  Mode => In_File,  Name => "input.txt");
   Create     (File => Output, Mode => Out_File, Name => "output.txt");
   loop
      Read  (File => Input,  Item => Buffer);
      Buffer := Value(Map => My_Map, Element => Buffer);
      Write (File => Output, Item => Buffer);
   end loop;
exception
   when Char_IO.End_Error =>
      if Is_Open(Input) then
         Close (Input);
      end if;
      if Is_Open(Output) then
         Close (Output);
      end if;
end Cipher;
