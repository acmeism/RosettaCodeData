with Binary_Searches;
with SPARK_IO;

--# inherit  Binary_Searches,
--#          SPARK_IO;

--# main_program;
procedure Test_Binary_Search
--# global in out SPARK_IO.Outputs;
--# derives SPARK_IO.Outputs from *;
is

   subtype Index_Type5 is Binary_Searches.Index_Type range 1 .. 5;
   subtype Index_Type7 is Binary_Searches.Index_Type range 1 .. 7;
   subtype Index_Type9 is Binary_Searches.Index_Type range 91 .. 99;
   -- Needed to define a constrained Array_Type.

   subtype Array_Type5 is Binary_Searches.Array_Type (Index_Type5);
   subtype Array_Type7 is Binary_Searches.Array_Type (Index_Type7);
   subtype Array_Type9 is Binary_Searches.Array_Type (Index_Type9);
   -- Needed to pass an array literal to Run_Search.
   -- SPARK does not allow an unconstrained type mark for that purpose.

   procedure Run_Search (Source : in     Binary_Searches.Array_Type;
                         Item   : in     Binary_Searches.Item_Type)
   --# global in out SPARK_IO.Outputs;
   --# derives SPARK_IO.Outputs from *,
   --#                               Item,
   --#                               Source;
   is
      Found    : Boolean;
      Position : Binary_Searches.Index_Type;
   begin
      SPARK_IO.Put_String (File => SPARK_IO.Standard_Output,
                           Item => "Searching for ",
                           Stop => 0);
      SPARK_IO.Put_Integer (File  => SPARK_IO.Standard_Output,
                            Item  => Item,
                            Width => 3,
                            Base  => 10);
      SPARK_IO.Put_String (File => SPARK_IO.Standard_Output,
                           Item => " in (",
                           Stop => 0);
      for Source_Index in Binary_Searches.Index_Type range Source'Range loop
         SPARK_IO.Put_Integer (File  => SPARK_IO.Standard_Output,
                               Item  => Source (Source_Index),
                               Width => 3,
                               Base  => 10);
      end loop;
      SPARK_IO.Put_String (File => SPARK_IO.Standard_Output,
                           Item => "): ",
                           Stop => 0);
      Binary_Searches.Search (Source   => Source,    -- in
                              Item     => Item,      -- in
                              Found    => Found,     -- out
                              Position => Position); -- out
      if Found then
         SPARK_IO.Put_String (File => SPARK_IO.Standard_Output,
                              Item => "found as #",
                              Stop => 0);
         SPARK_IO.Put_Integer (File  => SPARK_IO.Standard_Output,
                               Item  => Position,
                               Width => 0, -- to stick to the sibling '#' sign.
                               Base  => 10);
         SPARK_IO.Put_Line (File => SPARK_IO.Standard_Output,
                            Item => ".",
                            Stop => 0);
      else
         SPARK_IO.Put_Line (File => SPARK_IO.Standard_Output,
                            Item => "not found.",
                            Stop => 0);
      end if;
   end Run_Search;

begin
   SPARK_IO.New_Line (File => SPARK_IO.Standard_Output, Spacing => 1);
   Run_Search (Source => Array_Type5'(0, 1, 2, 3, 4), Item => 3);
   Run_Search (Source => Array_Type5'(2, 4, 6, 8, 10), Item => 3);
   Run_Search (Source => Array_Type7'(1, 2, 3, 4, 5, 6, 7), Item => 0);
   Run_Search (Source => Array_Type7'(1, 2, 3, 4, 5, 6, 7), Item => 7);
   Run_Search (Source => Array_Type9'(1, 2, 3, 4, 5, 6, 7, 8, 9), Item => 10);
   Run_Search (Source => Array_Type9'(1, 2, 3, 4, 5, 6, 7, 8, 9), Item => 1);
   Run_Search (Source => Array_Type9'(1, 2, 3, 4, 5, 6, 7, 8, 9), Item => 6);
end Test_Binary_Search;
