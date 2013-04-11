with Mazes;
procedure Main is
   package Small_Mazes is new Mazes (Height => 8, Width => 11);
   My_Maze : Small_Mazes.Maze_Grid;
begin
   Small_Mazes.Initialize (My_Maze);
   Small_Mazes.Put (My_Maze);
end Main;
