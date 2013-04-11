with Gnat.Regpat;

package Parse_Lines is

   Word_Pattern: constant String := "([a-zA-Z]+)";
   Filename_Pattern: constant String := "([a-zA-Z0-9_.,;:]+)";

   procedure Search_For_Pattern(Pattern: Gnat.Regpat.Pattern_Matcher;
                                Search_In: String;
                                First, Last: out Positive;
                                Found: out Boolean);

   function Compile(Raw: String) return Gnat.Regpat.Pattern_Matcher;

   generic
      Pattern: String;
      with procedure Do_Something(Word: String);
   procedure Iterate_Words(S: String);

end Parse_Lines;
