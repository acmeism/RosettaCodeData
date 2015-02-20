with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Twelve_Days_Of_Christmas is
   type Days is (First, Second, Third, Fourth, Fifth, Sixth,
		 Seventh, Eighth, Ninth, Tenth, Eleventh, Twelfth);

   package E_IO is new Ada.Text_IO.Enumeration_IO(Days);
   use E_IO;

   Gifts : array (Days) of Unbounded_String :=
     (To_Unbounded_String(" A partridge in a pear-tree."),
      To_Unbounded_String(" Two turtle doves"),
      To_Unbounded_String(" Three French hens"),
      To_Unbounded_String(" Four calling birds"),
      To_Unbounded_String(" Five golden rings"),
      To_Unbounded_String(" Six geese a-laying"),
      To_Unbounded_String(" Seven swans a-swimming"),
      To_Unbounded_String(" Eight maids a-milking"),
      To_Unbounded_String(" Nine ladies dancing"),
      To_Unbounded_String(" Ten lords a-leaping"),
      To_Unbounded_String(" Eleven pipers piping"),
      To_Unbounded_String(" Twelve drummers drumming"));
begin
   for Day in Days loop
      Put("On the "); Put(Day, Set => Lower_Case); Put(" day of Christmas,");
      New_Line; Put_Line("My true love gave to me:");
      for D in reverse Days'First..Day loop
	 Put_Line(To_String(Gifts(D)));
      end loop;
      if Day = First then
	 Replace_Slice(Gifts(Day), 2, 2, "And a");
      end if;
      New_Line;
   end loop;
end Twelve_Days_Of_Christmas;
