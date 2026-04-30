with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with Ada.Characters.Handling; use Ada.Characters.Handling;
procedure pangram is

   function ispangram(txt: String) return Boolean is
     (Is_Subset(To_Set(Span => ('a','z')), To_Set(To_Lower(txt))));

begin
   put_line(Boolean'Image(ispangram("This is a test")));
   put_line(Boolean'Image(ispangram("The quick brown fox jumps over the lazy dog")));
   put_line(Boolean'Image(ispangram("NOPQRSTUVWXYZ  abcdefghijklm")));
   put_line(Boolean'Image(ispangram("abcdefghijklopqrstuvwxyz"))); --Missing m, n
end pangram;
