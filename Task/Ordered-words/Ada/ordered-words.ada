with Ada.Text_IO, Ada.Containers.Indefinite_Vectors;
use Ada.Text_IO;

procedure Ordered_Words is
   package Word_Vectors is new Ada.Containers.Indefinite_Vectors
      (Index_Type => Positive, Element_Type => String);
   use Word_Vectors;
   File : File_Type;
   Ordered_Words : Vector;
   Max_Length : Positive := 1;
begin
   Open (File, In_File, "unixdict.txt");
   while not End_Of_File (File) loop
      declare
         Word : String := Get_Line (File);
      begin
         if (for all i in Word'First..Word'Last-1 => Word (i) <= Word(i+1)) then
            if Word'Length > Max_Length then
               Max_Length := Word'Length;
               Ordered_Words.Clear;
               Ordered_Words.Append (Word);
            elsif Word'Length = Max_Length then
               Ordered_Words.Append (Word);
            end if;
         end if;
      end;
   end loop;
   for Word of Ordered_Words loop
     Put_Line (Word);
   end loop;
   Close (File);
end Ordered_Words;
