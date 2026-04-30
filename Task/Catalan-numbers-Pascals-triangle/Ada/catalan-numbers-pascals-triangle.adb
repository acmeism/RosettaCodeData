with Ada.Text_IO, Pascal;

procedure Catalan is

   Last: Positive := 15;
   Row: Pascal.Row := Pascal.First_Row(2*Last+1);

begin
   for I in 1 .. Last loop
      Row := Pascal.Next_Row(Row);
      Row := Pascal.Next_Row(Row);
      Ada.Text_IO.Put(Integer'Image(Row(I+1)-Row(I+2)));
   end loop;
end Catalan;
