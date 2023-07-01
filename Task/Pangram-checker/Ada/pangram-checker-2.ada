with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Handling; use Ada.Characters.Handling;
procedure pangram is

  function ispangram(txt : in String) return Boolean is
     (for all Letter in Character range 'a'..'z' =>
         (for some Char of txt => To_Lower(Char) = Letter));

begin
   put_line(Boolean'Image(ispangram("This is a test")));
   put_line(Boolean'Image(ispangram("The quick brown fox jumps over the lazy dog")));
   put_line(Boolean'Image(ispangram("NOPQRSTUVWXYZ  abcdefghijklm")));
   put_line(Boolean'Image(ispangram("abcdefghijklopqrstuvwxyz"))); --Missing m, n
end pangram;
