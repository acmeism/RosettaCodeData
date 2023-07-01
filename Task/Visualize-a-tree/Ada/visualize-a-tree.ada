with Ada.Text_IO, Ada.Directories;

procedure Directory_Tree is

   procedure Print_Tree(Current: String; Indention: Natural := 0) is

      function Spaces(N: Natural) return String is
	 (if N= 0 then "" else " " & Spaces(N-1));

      use Ada.Directories;
      Search: Search_Type;
      Found: Directory_Entry_Type;

   begin
      Start_Search(Search, Current, "");
      while More_Entries(Search) loop
	 Get_Next_Entry(Search, Found);
	 declare
	    Name: String := Simple_Name(Found);
	    Dir: Boolean := Kind(Found) = Directory;
	 begin
	    if Name(Name'First) /= '.' then
               -- skip all files who's names start with ".", namely "." and ".."
	       Ada.Text_IO.Put_Line(Spaces(2*Indention) & Simple_Name(Found)
		  & (if Dir then " (dir)" else ""));
	       if Dir then
		  Print_Tree(Full_Name(Found), Indention + 1);
	       end if;
	    end if;
	 end;	
     end loop;
   end Print_Tree;

begin
   Print_Tree(Ada.Directories.Current_Directory);
end Directory_Tree;
