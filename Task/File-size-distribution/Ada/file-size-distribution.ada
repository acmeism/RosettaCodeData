with Ada.Numerics.Elementary_Functions;
with Ada.Directories;    use Ada.Directories;
with Ada.Strings.Fixed;  use Ada.Strings;
with Ada.Command_Line;   use Ada.Command_Line;
with Ada.Text_IO;        use Ada.Text_IO;

with Dir_Iterators.Recursive;

procedure File_Size_Distribution is

   type Exponent_Type is range 0 .. 18;
   type File_Count    is range 0 .. Long_Integer'Last;
   Counts         : array (Exponent_Type) of File_Count := (others => 0);
   Non_Zero_Index : Exponent_Type   := 0;
   Directory_Name : constant String := (if Argument_Count = 0
                                        then "."
                                        else Argument (1));
   Directory_Walker : Dir_Iterators.Recursive.Recursive_Dir_Walk
     := Dir_Iterators.Recursive.Walk (Directory_Name);
begin
   if not Exists (Directory_Name) or else Kind (Directory_Name) /= Directory then
      Put_Line ("Directory does not exist");
      return;
   end if;

   for Directory_Entry of Directory_Walker loop
      declare
         use Ada.Numerics.Elementary_Functions;
         Size_Of_File : File_Size;
         Exponent     : Exponent_Type;
      begin
         if Kind (Directory_Entry) = Ordinary_File then
            Size_Of_File := Size (Directory_Entry);
            if Size_Of_File = 0 then
               Counts (0) := Counts (0) + 1;
            else
               Exponent := Exponent_Type (Float'Ceiling (Log (Float (Size_Of_File),
                                                              Base => 10.0)));
               Counts (Exponent) := Counts (Exponent) + 1;
            end if;
         end if;
      end;
   end loop;

   for I in reverse Counts'Range loop
      if Counts (I) /= 0 then
         Non_Zero_Index := I;
         exit;
      end if;
   end loop;

   for I in Counts'First .. Non_Zero_Index loop
      Put ("Less than 10**");
      Put (Fixed.Trim (Exponent_Type'Image (I), Side => Left));
      Put (": ");
      Put (File_Count'Image (Counts (I)));
      New_Line;
   end loop;
end File_Size_Distribution;
