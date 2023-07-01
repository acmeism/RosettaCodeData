with Fifo;
with Ada.Text_Io; use Ada.Text_Io;

procedure Fifo_Test is
   package Int_Fifo is new Fifo(Integer);
   use Int_Fifo;
   My_Fifo : Fifo_Type;
   Val : Integer;
begin
   for I in 1..10 loop
      Push(My_Fifo, I);
   end loop;
   while not Is_Empty(My_Fifo) loop
      Pop(My_Fifo, Val);
      Put_Line(Integer'Image(Val));
   end loop;
end Fifo_Test;
