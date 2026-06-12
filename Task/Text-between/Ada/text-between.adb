with Ada.Text_Io;
with Ada.Strings.Fixed;

procedure Text_Between is

   Default_Start : constant String := "start";
   Default_End   : constant String := "end";

   function Between (Item  : String;
                     First : String := Default_Start;
                     Last  : String := Default_End) return String
   is
      use Ada.Strings.Fixed;
      First_Pos : Natural;
      Last_Pos  : Natural;
   begin
      if First = Default_Start then
         First_Pos := Item'First;
      else
         First_Pos := Index (Item, First);
         if First_Pos = 0 then
            return "";
         else
            First_Pos := First_Pos + First'Length;
         end if;
      end if;

      if Last = Default_End then
         return Item (First_Pos .. Item'Last);
      else
         Last_Pos := Index (Item (First_Pos .. Item'Last), Last);
         if Last_Pos = 0 then
            return Item (First_Pos .. Item'Last);
         else
            return Item (First_Pos .. Last_Pos - 1);
         end if;
      end if;
   end Between;

   procedure Test_Between (Text, First, Last : String) is
      use Ada.Text_Io;
      function Quote (Item : String) return String is ("'" & Item & "'");
      Result : String renames Between (Text, First, Last);
   begin
      Put ("Text:   "); Put_Line (Quote (Text));
      Put ("Start:  "); Put_Line (Quote (First));
      Put ("End:    "); Put_Line (Quote (Last));
      Put ("Result: "); Put_Line (Quote (Result));
      New_Line;
   end Test_Between;

begin
   Test_Between ("Hello Rosetta Code world", First => "Hello ", Last => " world");
   Test_Between ("Hello Rosetta Code world", First => Default_Start, Last => " world");
   Test_Between ("Hello Rosetta Code world", First => "Hello ", Last => Default_End);
   Test_Between ("</div><div style=\""chinese\"">你好嗎</div>",
                 First => "<div style=\""chinese\"">", Last => "</div>");
   Test_Between ("<text>Hello <span>Rosetta Code</span> world</text><table style=\""myTable\"">",
                      First => "<text>", Last => "<table>");
   Test_Between ("<table style=\""myTable\""><tr><td>hello world</td></tr></table>",
                 First => "<table>", Last => "</table>");
   Test_Between ("The quick brown fox jumps over the lazy other fox",
                 First => "quick ", Last => " fox");
   Test_Between ("One fish two fish red fish blue fish", First => "fish ", Last => " red");
   Test_Between ("FooBarBazFooBuxQuux", First => "Foo", Last => "Foo");
end Text_Between;
