with Ada.Text_IO, Ada.Containers.Indefinite_Vectors, Ada.Strings.Fixed, Ada.Strings.Maps;
use Ada.Text_IO, Ada.Containers, Ada.Strings, Ada.Strings.Fixed, Ada.Strings.Maps;

procedure Tokenize is
   package String_Vectors is new Indefinite_Vectors (Positive, String);
   use String_Vectors;
   Input  : String   := "Hello,How,Are,You,Today";
   Start  : Positive := Input'First;
   Finish : Natural  := 0;
   Output : Vector   := Empty_Vector;
begin
   while Start <= Input'Last loop
      Find_Token (Input, To_Set (','), Start, Outside, Start, Finish);
      exit when Start > Finish;
      Output.Append (Input (Start .. Finish));
      Start := Finish + 1;
   end loop;
   for S of Output loop
      Put (S & ".");
   end loop;
end Tokenize;
