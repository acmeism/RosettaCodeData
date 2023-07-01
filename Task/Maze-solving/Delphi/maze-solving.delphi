procedure SolveMaze(var AMaze: TMaze; const S, E: TPoint);
var
  Route    : TRoute;
  Position : TPoint;
  V        : TPoint; // delta vector
begin
  ClearVisited(AMaze);
  Position := S;
  Route    := TStack<TPoint>.Create;
  with Position do
  try
    AMaze[x, y].Visited := True;
    repeat
      if (y > 0)         and not AMaze[x, y-1].Visited and AMaze[x, y].PassTop    then V := Point(0, -1) else
      if (x < mwidth-1)  and not AMaze[x+1, y].Visited and AMaze[x+1, y].PassLeft then V := Point(1,  0) else
      if (y < mheight-1) and not AMaze[x, y+1].Visited and AMaze[x, y+1].PassTop  then V := Point(0,  1) else
      if (x > 0)         and not AMaze[x-1, y].Visited and AMaze[x, y].PassLeft   then V := Point(-1, 0) else
      begin
        if Route.Count = 0 then Exit;  // we are back at start so no way found
        Position := Route.Pop;         // step back
        Continue;
      end;

      Route.Push(Position);            // save current position to route
      Offset(V);                       // move forward
      AMaze[x, y].Visited := True;
    until Position = E;                // solved

    ClearVisited(AMaze);
    while Route.Count > 0 do           // Route to Maze
      with Route.Pop do
        AMaze[x, y].Visited := True;

  finally
    Route.Free;
  end;
end;

procedure Main;
var
  Maze: TMaze;
  S, E: TPoint;
begin
  Randomize;
  PrepareMaze(Maze);
  S := Point(Random(mwidth), Random(mheight));
  E := Point(Random(mwidth), Random(mheight));
  SolveMaze(Maze, S, E);
  Write(MazeToString(Maze, S, E));
  ReadLn;
end;

begin
  Main;
end.
