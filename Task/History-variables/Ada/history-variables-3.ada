with Ada.Text_IO, History_Variables;

procedure Test_History is

   package Int_With_Hist is new History_Variables(Integer);

   -- define a history variable
   I: Int_With_Hist.Variable;

   Sum: Integer := 0;

begin

   -- assign three values
   I.Set(3);
   I.Set(I.Get + 4);
   I.Set(9);

   -- non-destructively display the history
   for N in reverse 0 .. I.Defined-1 loop
      Ada.Text_IO.Put(Integer'Image(I.Peek(N)));
   end loop;
   Ada.Text_IO.New_Line;

   -- recall the three values
   while I.Defined > 0 loop
      Sum := Sum + I.Get;
      I.Undo;
   end loop;
   Ada.Text_IO.Put_Line(Integer'Image(Sum));

end Test_History;
