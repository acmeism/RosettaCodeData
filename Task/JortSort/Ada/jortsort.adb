with Ada.Text_IO, Ada.Containers.Generic_Array_Sort;

procedure Jortsort is

   function Jort_Sort(List: String) return Boolean is
      procedure Sort is new Ada.Containers.Generic_Array_Sort
	(Positive, Character, Array_Type => String);
      Second_List: String := List;
   begin
      Sort(Second_List);
      return Second_List = List;
   end Jort_Sort;

   use Ada.Text_IO;
begin
   Put_Line("""abbigail"" sorted: " & Boolean'Image(Jort_Sort("abbigail")));
   Put_Line("""abbey"" sorted: " & Boolean'Image(Jort_Sort("abbey")));
end Jortsort;
