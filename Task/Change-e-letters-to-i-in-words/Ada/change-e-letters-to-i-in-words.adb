with Ada.Text_Io;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Containers.Indefinite_Ordered_Maps;

procedure Change_E_To_I is
   use Ada.Text_Io;
   use Ada.Strings;

   Filename : constant String := "unixdict.txt";
   Mapping  : constant Maps.Character_Mapping :=
     Maps.To_Mapping ("Ee", "Ii");

   package Dictionaries is
     new Ada.Containers.Indefinite_Ordered_Maps
       (Key_Type     => String,
        Element_Type => String);

   Dict    : Dictionaries.Map;
   File    : File_Type;
begin
   Open (File, In_File, Filename);
   while not End_Of_File (File) loop
      declare
         Word : constant String := Get_Line (File);
      begin
         Dict.Insert (Word, Word);
      end;
   end loop;
   Close (File);

   for Word of Dict loop
      declare
         Trans : constant String := Fixed.Translate (Word, Mapping);
      begin
         if Word /= Trans and Dict.Contains (Trans) and Word'Length >= 6 then
            Put (Word); Put (" -> "); Put (Trans); New_Line;
         end if;
      end;
   end loop;
end Change_E_To_I;
