with Ada.Calendar.Arithmetic;
with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Command_Line;

procedure Discordian is
   use Ada.Calendar;
   use Ada.Strings.Unbounded;
   use Ada.Command_Line;
   package UStr_IO renames Ada.Strings.Unbounded.Text_IO;

   subtype Year_Number is Integer range 3067 .. 3565;
   type Seasons is (Chaos, Discord, Confusion, Bureaucracy, The_Aftermath);
   type Days_Of_Week is (Sweetmorn, Boomtime, Pungenday,
                         Prickle_Prickle, Setting_Orange);
   subtype Day_Number is Integer range 1 .. 73;

   type Discordian_Date is record
      Year        : Year_Number;
      Season      : Seasons;
      Day         : Day_Number;
      Week_Day    : Days_Of_Week;
      Is_Tibs_Day : Boolean := False;
   end record;

   function Week_Day_To_Str(Day : Days_Of_Week) return Unbounded_String is
      s : Unbounded_String;
   begin
      case Day is
         when Sweetmorn       => s := To_Unbounded_String("Sweetmorn");
         when Boomtime        => s := To_Unbounded_String("Boomtime");
         when Pungenday       => s := To_Unbounded_String("Pungenday");
         when Prickle_Prickle => s := To_Unbounded_String("Prickle-Prickle");
         when Setting_Orange  => s := To_Unbounded_String("Setting Orange");
      end case;
      return s;
   end Week_Day_To_Str;

   function Holiday(Season: Seasons) return Unbounded_String is
      s : Unbounded_String;
   begin
      case Season is
         when Chaos         => s := To_Unbounded_String("Chaoflux");
         when Discord       => s := To_Unbounded_String("Discoflux");
         when Confusion     => s := To_Unbounded_String("Confuflux");
         when Bureaucracy   => s := To_Unbounded_String("Bureflux");
         when The_Aftermath => s := To_Unbounded_String("Afflux");
      end case;
      return s;
   end Holiday;

   function Apostle(Season: Seasons) return Unbounded_String is
      s : Unbounded_String;
   begin
      case Season is
         when Chaos         => s := To_Unbounded_String("Mungday");
         when Discord       => s := To_Unbounded_String("Mojoday");
         when Confusion     => s := To_Unbounded_String("Syaday");
         when Bureaucracy   => s := To_Unbounded_String("Zaraday");
         when The_Aftermath => s := To_Unbounded_String("Maladay");
      end case;
      return s;
   end Apostle;

   function Season_To_Str(Season: Seasons) return Unbounded_String is
      s : Unbounded_String;
   begin
      case Season is
         when Chaos         => s := To_Unbounded_String("Chaos");
         when Discord       => s := To_Unbounded_String("Discord");
         when Confusion     => s := To_Unbounded_String("Confusion");
         when Bureaucracy   => s := To_Unbounded_String("Bureaucracy");
         when The_Aftermath => s := To_Unbounded_String("The Aftermath");
      end case;
      return s;
   end Season_To_Str;

   procedure Convert (From : Time; To : out Discordian_Date) is
      use Ada.Calendar.Arithmetic;
      First_Day   : Time;
      Number_Days : Day_Count;
      Leap_Year   : boolean;
   begin
      First_Day   := Time_Of (Year => Year (From), Month => 1, Day => 1);
      Number_Days := From - First_Day;

      To.Year        := Year (Date => From) + 1166;
      To.Is_Tibs_Day := False;
      Leap_Year := False;
      if Year (Date => From) mod 4 = 0 then
          if Year (Date => From) mod 100 = 0 then
              if Year (Date => From) mod 400 = 0 then
                  Leap_Year := True;
              end if;
          else
              Leap_Year := True;
          end if;
      end if;
      if Leap_Year then
         if Number_Days > 59 then
            Number_Days := Number_Days - 1;
         elsif Number_Days = 59 then
            To.Is_Tibs_Day := True;
         end if;
      end if;
      To.Day := Day_Number (Number_Days mod 73 + 1);
      case Number_Days / 73 is
         when 0 => To.Season := Chaos;
         when 1 => To.Season := Discord;
         when 2 => To.Season := Confusion;
         when 3 => To.Season := Bureaucracy;
         when 4 => To.Season := The_Aftermath;
         when others => raise Constraint_Error;
      end case;
      case Number_Days mod 5 is
         when 0 => To.Week_Day := Sweetmorn;
         when 1 => To.Week_Day := Boomtime;
         when 2 => To.Week_Day := Pungenday;
         when 3 => To.Week_Day := Prickle_Prickle;
         when 4 => To.Week_Day := Setting_Orange;
         when others => raise Constraint_Error;
      end case;
   end Convert;

   procedure Put (Item : Discordian_Date) is
   begin
      if Item.Is_Tibs_Day then
         Ada.Text_IO.Put ("St. Tib's Day");
      else
         UStr_IO.Put (Week_Day_To_Str(Item.Week_Day));
         Ada.Text_IO.Put (", day" & Integer'Image (Item.Day));
         Ada.Text_IO.Put (" of ");
         UStr_IO.Put (Season_To_Str (Item.Season));
         if Item.Day = 5 then
            Ada.Text_IO.Put (", ");
            UStr_IO.Put (Apostle(Item.Season));
         elsif Item.Day = 50 then
            Ada.Text_IO.Put (", ");
            UStr_IO.Put (Holiday(Item.Season));
         end if;
      end if;
      Ada.Text_IO.Put (" in the YOLD" & Integer'Image (Item.Year));
      Ada.Text_IO.New_Line;
   end Put;

   Test_Day  : Time;
   Test_DDay : Discordian_Date;
   Year : Integer;
   Month : Integer;
   Day : Integer;
   YYYYMMDD : Integer;
begin

   if Argument_Count = 0 then
      Test_Day := Clock;
      Convert (From => Test_Day, To => Test_DDay);
      Put (Test_DDay);
   end if;

   for Arg in 1..Argument_Count loop

      if Argument(Arg)'Length < 8 then
         Ada.Text_IO.Put("ERROR: Invalid Argument : '" & Argument(Arg) & "'");
         Ada.Text_IO.Put("Input format YYYYMMDD");
         raise Constraint_Error;
      end if;

      begin
         YYYYMMDD := Integer'Value(Argument(Arg));
      exception
         when Constraint_Error =>
            Ada.Text_IO.Put("ERROR: Invalid Argument : '" & Argument(Arg) & "'");
            raise;
      end;

      Day := YYYYMMDD mod 100;
      if Day < Day_Number'First or Day > Day_Number'Last then
         Ada.Text_IO.Put("ERROR: Invalid Day:" & Integer'Image(Day));
         raise Constraint_Error;
      end if;

      Month := ((YYYYMMDD - Day) / 100) mod 100;
      if Month < Month_Number'First or Month > Month_Number'Last then
         Ada.Text_IO.Put("ERROR: Invalid Month:" & Integer'Image(Month));
         raise Constraint_Error;
      end if;

      Year := ((YYYYMMDD - Day - Month * 100) / 10000);
      if Year < 1901 or Year > 2399 then
         Ada.Text_IO.Put("ERROR: Invalid Year:" & Integer'Image(Year));
         raise Constraint_Error;
      end if;

      Test_Day := Time_Of (Year => Year, Month => Month, Day => Day);

      Convert (From => Test_Day, To => Test_DDay);
      Put (Test_DDay);

   end loop;

end Discordian;
