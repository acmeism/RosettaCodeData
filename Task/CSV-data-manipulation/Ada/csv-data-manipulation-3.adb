with CSV, Ada.Text_IO; use Ada.Text_IO;

procedure CSV_Data_Manipulation is
   Header: String := Get_Line;
begin
   Put_Line(Header & ", SUM");
   while not End_Of_File loop
      declare
         R: CSV.Row := CSV.Line(Get_Line);
         Sum: Integer := 0;
      begin
         while R.Next loop
            Sum := Sum + Integer'Value(R.Item);
            Put(R.Item & ",");
         end loop;
         Put_Line(Integer'Image(Sum));
      end;
   end loop;
end CSV_Data_Manipulation;
