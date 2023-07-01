with Ada.Text_IO;

procedure Puzzle_15 is

   type Direction is (Up, Down, Left, Right);
   type Row_Type is range 0 .. 3;
   type Col_Type is range 0 .. 3;
   type Tile_Type is range 0 .. 15;

   To_Col : constant array (Tile_Type) of Col_Type :=
     (3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2);
   To_Row : constant array (Tile_Type) of Row_Type :=
     (3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3);

   type Board_Type is array (Row_Type, Col_Type) of Tile_Type;

   Solved_Board : constant Board_Type :=
     ((1,   2,  3,  4),
      (5,   6,  7,  8),
      (9,  10, 11, 12),
      (13, 14, 15, 0));

   type Try_Type is
      record
         Board : Board_Type;
         Move  : Direction;
         Cost  : Integer;
         Row   : Row_Type;
         Col   : Col_Type;
      end record;

   Stack : array (0 .. 100) of Try_Type;
   Top             : Natural := 0;
   Iteration_Count : Natural := 0;

   procedure Move_Down is
      Board   : Board_Type         := Stack (Top).Board;
      Row     : constant Row_Type  := Stack (Top).Row;
      Col     : constant Col_Type  := Stack (Top).Col;
      Tile    : constant Tile_Type := Board (Row + 1, Col);
      Penalty : constant Integer   :=
        (if To_Row (Tile) <= Row then 0 else 1);
   begin
      Board (Row,     Col) := Tile;
      Board (Row + 1, Col) := 0;
      Stack (Top + 1) := (Board => Board,
                          Move  => Down,
                          Row   => Row + 1,
                          Col   => Col,
                          Cost  => Stack (Top).Cost + Penalty);
   end Move_Down;

   procedure Move_Up is
      Board   : Board_Type         := Stack (Top).Board;
      Row     : constant Row_Type  := Stack (Top).Row;
      Col     : constant Col_Type  := Stack (Top).Col;
      Tile    : constant Tile_Type := Board (Row - 1, Col);
      Penalty : constant Integer   :=
        (if To_Row (Tile) >= Row then 0 else 1);
   begin
      Board (Row,     Col) := Tile;
      Board (Row - 1, Col) := 0;
      Stack (Top + 1) := (Board => Board,
                          Move  => Up,
                          Row   => Row - 1,
                          Col   => Col,
                          Cost  => Stack (Top).Cost + Penalty);
   end Move_Up;

   procedure Move_Left is
      Board   : Board_Type         := Stack (Top).Board;
      Row     : constant Row_Type  := Stack (Top).Row;
      Col     : constant Col_Type  := Stack (Top).Col;
      Tile    : constant Tile_Type := Board (Row, Col - 1);
      Penalty : constant Integer :=
        (if To_Col (Tile) >= Col then 0 else 1);
   begin
      Board (Row, Col)     := Tile;
      Board (Row, Col - 1) := 0;
      Stack (Top + 1) := (Board => Board,
                          Move  => Left,
                          Row   => Row,
                          Col   => Col - 1,
                          Cost  => Stack (Top).Cost + Penalty);
   end Move_Left;

   procedure Move_Right is
      Board   : Board_Type         := Stack (Top).Board;
      Row     : constant Row_Type  := Stack (Top).Row;
      Col     : constant Col_Type  := Stack (Top).Col;
      Tile    : constant Tile_Type := Board (Row, Col + 1);
      Penalty : constant Integer :=
        (if To_Col (Tile) <= Col then 0 else 1);
   begin
      Board (Row, Col)     := Tile;
      Board (Row, Col + 1) := 0;
      Stack (Top + 1) := (Board => Board,
                          Move  => Right,
                          Row   => Row,
                          Col   => Col + 1,
                          Cost  => Stack (Top).Cost + Penalty);
   end Move_Right;

   function Is_Solution return Boolean;

   function Test_Moves return Boolean is
   begin
      if
        Stack (Top).Move /= Down and then
        Stack (Top).Row  /= Row_Type'First
      then
         Move_Up;
         Top := Top + 1;
         if Is_Solution then return True; end if;
         Top := Top - 1;
      end if;

      if
        Stack (Top).Move /= Up and then
        Stack (Top).Row  /= Row_Type'Last
      then
         Move_Down;
         Top := Top + 1;
         if Is_Solution then return True; end if;
         Top := Top - 1;
      end if;

      if
        Stack (Top).Move /= Right and then
        Stack (Top).Col  /= Col_Type'First
      then
         Move_Left;
         Top := Top + 1;
         if Is_Solution then return True; end if;
         Top := Top - 1;
      end if;

      if
        Stack (Top).Move /= Left and then
        Stack (Top).Col  /= Col_Type'Last
      then
         Move_Right;
         Top := Top + 1;
         if Is_Solution then return True; end if;
         Top := Top - 1;
      end if;

      return False;
   end Test_Moves;

   function Is_Solution return Boolean is
      use Ada.Text_IO;
   begin
      if Stack (Top).Board = Solved_Board then
         Put ("Solved in " & Top'Image & " moves: ");
         for R in 1 .. Top loop
            Put (String'(Stack (R).Move'Image) (1));
         end loop;
         New_Line;
         return True;
      end if;
      if Stack (Top).Cost <= Iteration_Count then
         return Test_Moves;
      end if;
      return False;
   end Is_Solution;

   procedure Solve (Row   : in Row_Type;
                    Col   : in Col_Type;
                    Board : in Board_Type) is
   begin
      pragma Assert (Board (Row, Col) = 0);
      Top := 0;
      Iteration_Count := 0;
      Stack (Top) := (Board => Board,
                      Row   => Row,
                      Col   => Col,
                      Move  => Down,
                      Cost  => 0);
      while not Is_Solution loop
         Iteration_Count := Iteration_Count + 1;
      end loop;
   end Solve;

begin
   Solve (Row   => 2,
          Col   => 0,
          Board => ((15, 14, 1, 6),
                    (9, 11, 4, 12),
                    (0, 10, 7, 3),
                    (13, 8, 5, 2)));
end Puzzle_15;
