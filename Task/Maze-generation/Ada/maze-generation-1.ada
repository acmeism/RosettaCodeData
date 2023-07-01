generic
   Height : Positive;
   Width : Positive;
package Mazes is

   type Maze_Grid is private;

   procedure Initialize (Maze : in out Maze_Grid);

   procedure Put (Item : Maze_Grid);

private

   type Directions is (North, South, West, East);

   type Cell_Walls is array (Directions) of Boolean;
   type Cells is record
      Walls   : Cell_Walls := (others => True);
      Visited : Boolean    := False;
   end record;

   subtype Height_Type is Positive range 1 .. Height;
   subtype Width_Type is Positive range 1 .. Width;

   type Maze_Grid is array (Height_Type, Width_Type) of Cells;

end Mazes;
