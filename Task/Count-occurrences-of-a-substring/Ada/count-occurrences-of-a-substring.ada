with Ada.Strings.Fixed, Ada.Integer_Text_IO;

procedure Substrings is
begin
   Ada.Integer_Text_IO.Put (Ada.Strings.Fixed.Count (Source  => "the three truths",
                                                     Pattern => "th"));
   Ada.Integer_Text_IO.Put (Ada.Strings.Fixed.Count (Source  => "ababababab",
                                                     Pattern => "abab"));
end Substrings;
