with Generic_Fifo;
with Ada.Text_Io; use Ada.Text_Io;

procedure Generic_Fifo_Test is
   package Int_Fifo is new Generic_Fifo(Integer);
   use Int_Fifo;
   My_Fifo : Fifo_Type;
   Val : Integer;
begin
   for I in 1..10 loop
      My_Fifo.Push(I);
   end loop;
   while not My_Fifo.Is_Empty loop
      My_Fifo.Pop(Val);
      Put_Line(Integer'Image(Val));
   end loop;
end Generic_Fifo_Test;
