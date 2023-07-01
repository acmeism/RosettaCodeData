with Ada.Text_IO, History_Variables;

procedure Test_History is

   package Str_With_Hist is new History_Variables(String);

   -- define a history variable
   S: Str_With_Hist.Variable;

   Sum: Integer := 0;

begin

   -- assign three values
   S.Set("one");
   S.Set(S.Get & S.Get); --"oneone"
   S.Set("three");

   -- non-destructively display the history
   for N in reverse 0 .. S.Defined-1 loop
      Ada.Text_IO.Put(S.Peek(Generation => N) &" ");
   end loop;
   Ada.Text_IO.New_Line;

   -- recall the three values
   while S.Defined > 0 loop
      Sum := Sum + S.Get'Length;
      S.Undo;
   end loop;
   Ada.Text_IO.Put_Line(Integer'Image(Sum));

end Test_History;
