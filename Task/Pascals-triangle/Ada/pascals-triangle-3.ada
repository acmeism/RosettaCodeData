with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Command_Line, Pascal; use Pascal;

procedure Triangle is

   Number_Of_Rows: Positive := Integer'Value(Ada.Command_Line.Argument(1));
   Row: Pascal.Row := First_Row(Number_Of_Rows);

begin
   loop
      -- print one row
      for J in 1 .. Length(Row) loop
	 Ada.Integer_Text_IO.Put(Row(J), 5);
      end loop;
      Ada.Text_IO.New_Line;
      exit when Length(Row) >= Number_Of_Rows;
      Row := Next_Row(Row);
   end loop;
end Triangle;
