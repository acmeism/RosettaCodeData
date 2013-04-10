with Ada.Calendar.Formatting;

package Printable_Calendar is

   subtype String20 is String(1 .. 20);
   type Month_Rep_Type is array (Ada.Calendar.Month_Number) of String20;

   type Description is record
      Weekday_Rep: String20;
      Month_Rep: Month_Rep_Type;
   end record;
   -- for internationalization, you only need to define a new description

   Default_Description: constant Description :=
     (Weekday_Rep =>
       "Mo Tu We Th Fr Sa So",
      Month_Rep   =>
      ("      January       ", "      February      ", "       March        ",
       "       April        ", "        May         ", "        June        ",
       "        July        ", "       August       ", "      September     ",
       "       October      ", "      November      ", "      December      "));

   type Calendar (<>) is tagged private;

   -- Initialize a calendar for devices with 80- or 132-characters per row
   function Init_80(Des: Description := Default_Description) return Calendar;
   function Init_132(Des: Description := Default_Description) return Calendar;

   -- the following procedures output to standard IO; override if neccessary
   procedure New_Line(Cal: Calendar);
   procedure Put_String(Cal: Calendar; S: String);

   -- the following procedures do the real stuff
   procedure Print_Line_Centered(Cal: Calendar'Class; Line: String);
   procedure Print(Cal: Calendar'Class;
                   Year:  Ada.Calendar.Year_Number;
                   Year_String: String); -- this is the main Thing

private
      type Calendar is tagged record
      Columns, Rows, Space_Between_Columns: Positive;
      Left_Space: Natural;

      Weekday_Rep: String20;
      Month_Rep: Month_Rep_Type;
   end record;

end Printable_Calendar;
