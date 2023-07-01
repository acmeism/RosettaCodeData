-- Kernighans large earthquake problem
with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
use Ada.Strings;

procedure Main is
   Inpt_File : File_Type;
   Space     : Natural;
begin
   Open (File => Inpt_File, Mode => In_File, Name => "data.txt");
   while not End_Of_File (Inpt_File) loop
      declare
         Line : String :=
           Trim (Source => Get_Line (File => Inpt_File), Side => Both);
      begin

         if Line'Length > 0 then
            Space := Line'Last;
            loop
               exit when Line (Space) = ' ' or else Space = 0;
               Space := Space - 1;
            end loop;

            if Space > 0 then
               if Float'Value (Line (Space .. Line'Last)) > 6.0 then
                  Put_Line (Line);
               end if;
            end if;
         end if;
      end;
   end loop;
   Close (Inpt_File);
end Main;
