with Ada.Text_IO, Simple_Parse;

procedure Reverse_Words is

   function Reverse_Words(S: String) return String is
      Cursor: Positive := S'First;
      Word: String := Simple_Parse.Next_Word(S, Cursor);
   begin
      if Word = "" then
         return "";
      else
         return Reverse_Words(S(Cursor .. S'Last)) & " " & Word;
      end if;
   end Reverse_Words;

   use Ada.Text_IO;
begin
   while not End_Of_File loop
      Put_Line(Reverse_Words(Get_Line)); -- poem is read from standard input
   end loop;
end Reverse_Words;
