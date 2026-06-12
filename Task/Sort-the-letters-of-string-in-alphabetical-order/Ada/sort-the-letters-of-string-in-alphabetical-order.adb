with Ada.Text_Io;
with Ada.Containers.Generic_Array_Sort;

procedure Sort_Letters is

   function Compare (Left, Right : Character) return Boolean
   is (Left < Right);

   procedure Sort is new
     Ada.Containers.Generic_Array_Sort (Index_Type   => Positive,
                                        Element_Type => Character,
                                        Array_Type   => String,
                                        "<"          => Compare);

   use Ada.Text_Io;
   B : String := "When Roman engineers built a bridge, they had to stand under it while the first legion marched across. If programmers today worked under similar ground rules, they might well find themselves getting much more interested in Ada!";

begin
   Put_Line (B); Sort (B); Put_Line (B);
end Sort_Letters;
