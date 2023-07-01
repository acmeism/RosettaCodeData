generic
   Rows, Cols: Positive;
   with function Name(N: Natural) return String; -- with Pre => (N < Rows*Cols);
   -- Name(0) shall return the name for the empty tile
package Generic_Puzzle is

   subtype Row_Type is Positive range 1 .. Rows;
   subtype Col_Type is Positive range 1 .. Cols;
   type Moves is (Up, Down, Left, Right);
   type Move_Arr is array(Moves) of Boolean;

   function Get_Point(Row: Row_Type; Col: Col_Type) return String;
   function Possible return Move_Arr;
   procedure Move(The_Move: Moves);

end Generic_Puzzle;
