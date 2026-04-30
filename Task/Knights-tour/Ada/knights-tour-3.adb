with Knights_Tour, Ada.Command_Line;

procedure Test_Knight is

   Size: Positive := Positive'Value(Ada.Command_Line.Argument(1));

   package KT is new Knights_Tour(Size => Size);

begin
   KT.Tour_IO(KT.Get_Tour(1, 1));
end Test_Knight;
