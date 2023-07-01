program ConvexHulls;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Types,
  System.SysUtils,
  System.Generics.Defaults,
  System.Generics.Collections;

  function Ccw(const a, b, c: TPoint): Boolean;
  begin
    Result := ((b.X - a.X) * (c.Y - a.Y)) > ((b.Y - a.Y) * (c.X - a.X));
  end;

  function ConvexHull(const p: TList<TPoint>): TList<TPoint>;
  var
    pt: TPoint;
    i, t: Integer;
  begin
    Result := TList<TPoint>.Create;

    if (p.Count = 0) then Exit;

    p.Sort(TComparer<TPoint>.Construct(
          function(const Left, Right: TPoint): Integer
          begin
            Result := Left.X - Right.X;
          end
    ));

    // lower hull
    for i := 0 to p.Count-1 do
    begin
      pt := p[i];
      while ((Result.Count >= 2) and (not Ccw(Result[Result.Count - 2], Result[Result.Count - 1], pt))) do
      begin
        Result.Delete(Result.Count - 1);
      end;
      Result.Add(pt);
    end;

    // upper hull
    t := Result.Count + 1;
    for i := p.Count-1 downto 0 do
    begin
      pt := p[i];
      while ((Result.Count >= t) and (not Ccw(Result[Result.Count - 2], Result[Result.Count - 1], pt))) do
      begin
        Result.Delete(Result.Count - 1);
      end;
      Result.Add(pt);
    end;

    Result.Delete(Result.Count - 1);
  end;

var
  points: TList<TPoint>;
  hull: TList<TPoint>;
  i: Integer;
begin

  hull := nil;
  points := TList<TPoint>.Create;
  try

    points.AddRange([
        Point(16, 3),
        Point(12, 17),
        Point(0, 6),
        Point(-4, -6),
        Point(16, 6),
        Point(16, -7),
        Point(16, -3),
        Point(17, -4),
        Point(5, 19),
        Point(19, -8),
        Point(3, 16),
        Point(12, 13),
        Point(3, -4),
        Point(17, 5),
        Point(-3, 15),
        Point(-3, -9),
        Point(0, 11),
        Point(-9, -3),
        Point(-4, -2),
        Point(12, 10)
        ]);

    hull := ConvexHull(points);

    // Output the result
    Write('Convex Hull: [');
    for i := 0 to hull.Count-1 do
    begin
      if (i > 0) then Write(', ');
      Write(Format('(%d, %d)', [hull[i].X, hull[i].Y]));
    end;
    WriteLn(']');

  finally
    hull.Free;
    points.Free;
  end;

end.
