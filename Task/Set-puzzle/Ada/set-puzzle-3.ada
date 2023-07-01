with Ada.Text_IO, Set_Puzzle, Ada.Command_Line;

procedure Puzzle is

   package TIO renames Ada.Text_IO;

   Card_Count:     Positive := Positive'Value(Ada.Command_Line.Argument(1));
   Required_Sets:  Positive := Positive'Value(Ada.Command_Line.Argument(2));

   Cards: Set_Puzzle.Cards(1 .. Card_Count);

   function Cnt_Sets(C: Set_Puzzle.Cards) return Natural is
      Cnt: Natural := 0;
      procedure Count_Sets(C: Set_Puzzle.Cards; S: Set_Puzzle.Set) is
      begin
         Cnt := Cnt + 1;
      end Count_Sets;
      procedure CS is new Set_Puzzle.Find_Sets(Count_Sets);
   begin
      CS(C);
      return Cnt;
   end Cnt_Sets;

   procedure Print_Sets(C: Set_Puzzle.Cards) is
      procedure Print_A_Set(C: Set_Puzzle.Cards; S: Set_Puzzle.Set) is
      begin
         TIO.Put("(" & Integer'Image(S(1)) & "," & Integer'Image(S(2))
                   & "," & Integer'Image(S(3)) & " )  ");
      end Print_A_Set;
      procedure PS is new Set_Puzzle.Find_Sets(Print_A_Set);
   begin
      PS(C);
      TIO.New_Line;
   end Print_Sets;

begin
   loop    -- deal random cards
      Set_Puzzle.Deal_Cards(Cards);
      exit when Cnt_Sets(Cards) = Required_Sets;
   end loop;    -- until number of sets is as required

   for I in Cards'Range loop    -- print the cards
      if I < 10 then
         TIO.Put(" ");
      end if;
      TIO.Put_Line(Integer'Image(I) & " " & Set_Puzzle.To_String(Cards(I)));
   end loop;

   Print_Sets(Cards);    -- print the sets
end Puzzle;
