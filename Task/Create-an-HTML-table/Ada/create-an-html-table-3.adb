with Ada.Text_IO, Ada.Numerics.Discrete_Random, HTML_Table;

procedure Test_HTML_Table is

   -- define the Item_Type and the random generator
   type  Four_Digits is mod 10_000;
   package Rand is new Ada.Numerics.Discrete_Random(Four_Digits);
   Gen: Rand.Generator;

   -- now we instantiate the generic package HTML_Table
   package T is new HTML_Table
     (Item_Type => Four_Digits,
      To_String => Four_Digits'Image,
      Put       => Ada.Text_IO.Put,
      Put_Line  => Ada.Text_IO.Put_Line);

   -- define the object that will the values that the table contains
   The_Table: T.Item_Array(1 .. 4, 1..3);

begin
   -- fill The_Table with random values
   Rand.Reset(Gen);
   for Rows in The_Table'Range(1) loop
      for Cols in The_Table'Range(2) loop
         The_Table(Rows, Cols) := Rand.Random(Gen);
      end loop;
   end loop;

   -- output The_Table
   T.Print(Items        => The_Table,
           Column_Heads => (T.Convert("X"), T.Convert("Y"), T.Convert("Z")));
end Test_HTML_Table;
