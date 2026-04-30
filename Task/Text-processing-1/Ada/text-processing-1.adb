with Ada.Text_IO;            use Ada.Text_IO;
with Strings_Edit;           use Strings_Edit;
with Strings_Edit.Floats;    use Strings_Edit.Floats;
with Strings_Edit.Integers;  use Strings_Edit.Integers;

procedure Data_Munging is
   Syntax_Error : exception;
   type Gap_Data is record
      Count   : Natural := 0;
      Line    : Natural := 0;
      Pointer : Integer;
      Year    : Integer;
      Month   : Integer;
      Day     : Integer;
   end record;
   File    : File_Type;
   Max     : Gap_Data;
   This    : Gap_Data;
   Current : Gap_Data;
   Count   : Natural := 0;
   Sum     : Float   := 0.0;
begin
   Open (File, In_File, "readings.txt");
   loop
      declare
         Line    : constant String := Get_Line (File);
         Pointer : Integer := Line'First;
         Flag    : Integer;
         Data    : Float;
      begin
         Current.Line := Current.Line + 1;
         Get (Line, Pointer, SpaceAndTab);
         Get (Line, Pointer, Current.Year);
         Get (Line, Pointer, Current.Month);
         Get (Line, Pointer, Current.Day);
         while Pointer <= Line'Last loop
            Get (Line, Pointer, SpaceAndTab);
            Current.Pointer := Pointer;
            Get (Line, Pointer, Data);
            Get (Line, Pointer, SpaceAndTab);
            Get (Line, Pointer, Flag);
            if Flag < 0 then
               if This.Count = 0 then
                  This := Current;
               end if;
               This.Count := This.Count + 1;
            else
               if This.Count > 0 and then Max.Count < This.Count then
                  Max := This;
               end if;
               This.Count := 0;
               Count := Count + 1;
               Sum   := Sum + Data;
            end if;
         end loop;
      exception
         when End_Error =>
            raise Syntax_Error;
      end;
   end loop;
exception
   when End_Error =>
      Close (File);
      if This.Count > 0 and then Max.Count < This.Count then
         Max := This;
      end if;
      Put_Line ("Average " & Image (Sum / Float (Count)) & " over " & Image (Count));
      if Max.Count > 0 then
         Put ("Max. " & Image (Max.Count) & " false readings start at ");
         Put (Image (Max.Line) & ':' & Image (Max.Pointer) & " stamped ");
         Put_Line (Image (Max.Year) & Image (Max.Month) & Image (Max.Day));
      end if;
   when others =>
      Close (File);
      Put_Line ("Syntax error at " & Image (Current.Line) & ':' & Image (Max.Pointer));
end Data_Munging;
