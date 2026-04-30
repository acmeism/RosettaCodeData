with Gnat.Regpat;

package body Parse_Lines is

   procedure Search_For_Pattern(Pattern: Gnat.Regpat.Pattern_Matcher;
                                Search_In: String;
                                First, Last: out Positive;
                                Found: out Boolean) is
      use Gnat.Regpat;
      Result: Match_Array (0 .. 1);
   begin
      Match(Pattern, Search_In, Result);
      Found := Result(1) /= No_Match;
      if Found then
         First := Result(1).First;
         Last := Result(1).Last;
      end if;
   end Search_For_Pattern;

   function Compile(Raw: String) return Gnat.Regpat.Pattern_Matcher is
   begin
      return Gnat.Regpat.Compile(Raw);
   end Compile;

      procedure Iterate_Words(S: String) is
      Current_First: Positive := S'First;
      First, Last:   Positive;
      Found:         Boolean;
      use Parse_Lines;
      Compiled_P: Gnat.Regpat.Pattern_Matcher := Compile(Pattern);
   begin
      loop
         Search_For_Pattern(Compiled_P,
                            S(Current_First .. S'Last),
                            First, Last, Found);
         exit when not Found;
         Do_Something(S(First .. Last));
         Current_First := Last+1;
      end loop;
   end Iterate_Words;

end Parse_Lines;
