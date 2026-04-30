with Knights_Tour, Ada.Text_IO, Ada.Command_Line;

procedure Holy_Knight is

   Size: Positive := Positive'Value(Ada.Command_Line.Argument(1));
   package KT is new Knights_Tour(Size => Size);
   Board: KT.Tour := (others => (others => Natural'Last));

   Start_X, Start_Y: KT.Index:= 1; -- default start place (1,1)
   S: String(KT.Index);
   I: Positive := KT.Index'First;
begin
   -- read the board from standard input
   while not Ada.Text_IO.End_Of_File and I <= Size loop
      S := Ada.Text_IO.Get_Line;
      for J in KT.Index loop
         if S(J) = ' ' or S(J) = '-' then
            Board(I,J) := Natural'Last;
         elsif S(J) = '1' then
              Start_X := I; Start_Y := J;  Board(I,J) := 1;
         else Board(I,J) := 0;
         end if;
      end loop;
      I := I + 1;
   end loop;

   -- print the board
   Ada.Text_IO.Put_Line("Start Configuration (Length:"
                          & Natural'Image(KT.Count_Moves(Board)) & "):");
   KT.Tour_IO(Board, Width => 1);
   Ada.Text_IO.New_Line;

   -- search for the tour and print it
   Ada.Text_IO.Put_Line("Tour:");
   KT.Tour_IO(KT.Warnsdorff_Get_Tour(Start_X, Start_Y, Board));
end Holy_Knight;
