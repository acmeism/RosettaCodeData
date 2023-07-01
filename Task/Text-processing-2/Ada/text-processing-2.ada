with Ada.Calendar;           use Ada.Calendar;
with Ada.Text_IO;            use Ada.Text_IO;
with Strings_Edit;           use Strings_Edit;
with Strings_Edit.Floats;    use Strings_Edit.Floats;
with Strings_Edit.Integers;  use Strings_Edit.Integers;

with Generic_Map;

procedure Data_Munging_2 is
   package Time_To_Line is new Generic_Map (Time, Natural);
   use Time_To_Line;
   File    : File_Type;
   Line_No : Natural := 0;
   Count   : Natural := 0;
   Stamps  : Map;
begin
   Open (File, In_File, "readings.txt");
   loop
      declare
         Line    : constant String := Get_Line (File);
         Pointer : Integer := Line'First;
         Flag    : Integer;
         Year, Month, Day : Integer;
         Data    : Float;
         Stamp   : Time;
         Valid   : Boolean := True;
      begin
         Line_No := Line_No + 1;
         Get (Line, Pointer, SpaceAndTab);
         Get (Line, Pointer, Year);
         Get (Line, Pointer, Month);
         Get (Line, Pointer, Day);
         Stamp := Time_Of (Year_Number (Year), Month_Number (-Month), Day_Number (-Day));
         begin
            Add (Stamps, Stamp, Line_No);
         exception
            when Constraint_Error =>
               Put (Image (Year) & Image (Month) & Image (Day) & ": record at " & Image (Line_No));
               Put_Line (" duplicates record at " & Image (Get (Stamps, Stamp)));
         end;
         Get (Line, Pointer, SpaceAndTab);
         for Reading in 1..24 loop
            Get (Line, Pointer, Data);
            Get (Line, Pointer, SpaceAndTab);
            Get (Line, Pointer, Flag);
            Get (Line, Pointer, SpaceAndTab);
            Valid := Valid and then Flag >= 1;
         end loop;
         if Pointer <= Line'Last then
            Put_Line ("Unrecognized tail at " & Image (Line_No) & ':' & Image (Pointer));
         elsif Valid then
            Count := Count + 1;
         end if;
      exception
         when End_Error | Data_Error | Constraint_Error | Time_Error =>
            Put_Line ("Syntax error at " & Image (Line_No) & ':' & Image (Pointer));
      end;
   end loop;
exception
   when End_Error =>
      Close (File);
      Put_Line ("Valid records " & Image (Count) & " of " & Image (Line_No) & " total");
end Data_Munging_2;
