with Ada.Text_IO, Ada.Directories, Ada.Containers.Indefinite_Vectors;

procedure Directory_List is

   use Ada.Directories, Ada.Text_IO;
   Search: Search_Type; Found: Directory_Entry_Type;
   package SV is new Ada.Containers.Indefinite_Vectors(Natural, String);
   Result: SV.Vector;
   package Sorting is new SV.Generic_Sorting; use Sorting;
   function SName return String is (Simple_Name(Found));

begin
   -- search directory and store it in Result, a vector of strings
   Start_Search(Search, Directory => ".", Pattern =>"");
   while More_Entries(Search) loop
      Get_Next_Entry(Search, Found);
      declare
         Name: String := Simple_Name(Found);
      begin
         if Name(Name'First) /= '.' then
            Result.Append(Name);
         end if; -- ingnore filenames beginning with "."
      end;
   end loop; -- Result holds the entire directory in arbitrary order

   Sort(Result); -- Result holds the directory in proper order

   -- print Result
   for I in Result.First_Index .. Result.Last_Index loop
      Put_Line(Result.Element(I));
   end loop;
end Directory_List;
