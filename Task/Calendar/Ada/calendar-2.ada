with Ada.Text_IO;

package body Printable_Calendar is

   use Ada.Calendar;
   package F renames Ada.Calendar.Formatting;

   function Days_Per_Month(Year: Year_Number; Month: Month_Number)
                          return Day_Number is
   begin
      case Month is
         when 1 | 3 | 5 | 7 | 8 | 10 | 12 => return 31;
         when 4 | 6 | 9 | 11              => return 30;
         when 2 =>
            if Year mod 4 /= 0 then
               return 28;
            elsif Year mod 100 /= 0 then
               return 29;
            elsif Year mod 400 /= 0 then
               return 28;
            else
               return 29;
            end if;
      end case;
   end Days_Per_Month;

   type Full_Month_Rep is array (1 .. 6) of String20;
   function Generate_Printable_Month (Y: Ada.Calendar.Year_Number;
                                      M: Ada.Calendar.Month_Number)
                                     return Full_Month_Rep is

      X: Full_Month_Rep := (others => "                    ");
      -- If X=Generate_Printable_Month(2011, 01), the result could be
      --  "       January      ", -- Month_Rep(01)
      --  "Mo Tu We Th Fr Sa Su"  -- Weekday_Rep
      --  "                1  2"  -- X(1)
      --  " 3  4  5  6  7  8  9"  -- X(2)
      --  "10 11 12 13 14 15 16"  -- X(3)
      --  "17 18 19 20 21 22 23"  -- X(4)
      --  "24 25 26 27 28 29 30"  -- X(5)
      --  "31                  "  -- X(6)

      Row:       Integer range 1 .. 6  := 1;
      Day_Index: constant array(F.Day_Name) of Positive
        := (1, 4, 7, 10, 13, 16, 19);
   begin
      for I in 1 .. Days_Per_Month(Y, M) loop
         declare
           Weekday: constant F.Day_Name    := F.Day_Of_Week(F.Time_Of(Y, M, I));
           Pos: constant Positive          := Day_Index(Weekday);
           Cleartext_Name: constant String := Day_Number'Image(I);
           L: constant Positive            := Cleartext_Name'Last;
         begin
            X(Row)(Pos .. Pos+1) := Cleartext_Name(L-1 .. L);
            if F."="(Weekday, F.Sunday) then
               Row := Row + 1;
            end if;
         end;
      end loop;
      return X;
   end Generate_Printable_Month;


   procedure Print(Cal: Calendar'class;
                   Year:  Ada.Calendar.Year_Number;
                   Year_String: String) is

      The_Month: Month_Number := Month_Number'First;

      procedure Write_Space(Length: Natural) is
      begin
         for I in 1 .. Length loop
            Cal.Put_String(" ");
         end loop;
      end Write_Space;

      Year_Rep: array(Month_Number) of Full_Month_Rep;

   begin
      -- print the year
      Cal.Print_Line_Centered(Year_String);

      -- generate a printable form for all the months
      for Month in Month_Number loop
         Year_Rep(Month) := Generate_Printable_Month(Year, Month);
      end loop;

      begin
         while True loop

            -- new line
            Cal.New_Line;

            -- write month names
            Write_Space(Cal.Left_Space);
            for Month in The_Month .. The_Month+Cal.Columns-2 loop
               Cal.Put_String(Cal.Month_Rep(Month));
               Write_Space(Cal.Space_Between_Columns);
            end loop;
            Cal.Put_String(Cal.Month_Rep(The_Month+Cal.Columns-1));
            Cal.New_Line;

            -- write "Mo Tu .. So" - or whatever is defined by Weekday_Rep
            Write_Space(Cal.Left_Space);
            for Month in The_Month .. The_Month+Cal.Columns-2 loop
               Cal.Put_String(Cal.Weekday_Rep);
               Write_Space(Cal.Space_Between_Columns);
            end loop;
            Cal.Put_String(Cal.Weekday_Rep);
            Cal.New_Line;

            -- write the dates
            for I in 1 .. 6 loop
               Write_Space(Cal.Left_Space);
               for Month in The_Month .. The_Month+Cal.Columns-2 loop
                  Cal.Put_String(Year_Rep(Month)(I));
                  Write_Space(Cal.Space_Between_Columns);
               end loop;
            Cal.Put_String(Year_Rep(The_Month+Cal.Columns-1)(I));
            Cal.New_Line;
            end loop;

            The_Month := The_Month + Cal.Columns;
            -- this will eventually raise Constraint_Error to terminate the loop
         end loop;
      exception
         when Constraint_Error => null;
      end;
   end Print;

   procedure New_Line(Cal: Calendar) is
   begin
      Ada.Text_IO.New_Line;
   end New_Line;

   procedure Put_String(Cal: Calendar; S: String) is
   begin
      Ada.Text_IO.Put(S);
   end Put_String;

   procedure Print_Line_Centered(Cal: Calendar'Class; Line: String) is
      Width : constant Positive := Cal.Columns*20
        + (Cal.Columns-1)*Cal.Space_Between_Columns
        + Cal.Left_Space;
   begin
      if Line'Length    >= Width-1 then
         Cal.Put_String(Line);
         Cal.New_Line;
      else
         Print_Line_Centered(Cal, " " & Line & " ");
      end if;
   end Print_Line_Centered;

   function Init_80(Des: Description := Default_Description) return Calendar is
      X: Calendar:=
        (Columns => 3, Rows => 4, Space_Between_Columns => 4,
         Left_Space => 1,
         Weekday_Rep =>  Des.Weekday_Rep,
         Month_Rep   =>  Des.Month_Rep
        );
   begin
      return X;
   end Init_80;

   function Init_132(Des: Description := Default_Description) return Calendar is
      X: Calendar:=
        (Columns => 6, Rows => 2, Space_Between_Columns => 2,
         Left_Space => 1,
         Weekday_Rep =>  Des.Weekday_Rep,
         Month_Rep   =>  Des.Month_Rep
        );
   begin
      return X;
   end Init_132;

end Printable_Calendar;
