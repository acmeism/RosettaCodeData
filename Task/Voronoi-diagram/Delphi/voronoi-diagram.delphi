uses System.Generics.Collections;

procedure TForm1.Voronoi;
const
   p = 3;
   cells = 100;
   size = 1000;

var
  aCanvas : TCanvas;
  px, py: array of integer;
  color: array of Tcolor;
  Img: TBitmap;
  lastColor:Integer;
  auxList: TList<TPoint>;
  poligonlist : TDictionary<integer,TList<TPoint>>;
  pointarray : array of TPoint;

  n,i,x,y,k,j: Integer;
  d1,d2: double;

  function distance(x1,x2,y1,y2 :Integer) : Double;
  begin
    result := sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)); ///Euclidian
    // result :=  abs(x1 - x2) + abs(y1 - y2); // Manhattan
    // result := power(power(abs(x1 - x2), p) + power(abs(y1 - y2), p), (1 / p)); // Minkovski
  end;

begin

    poligonlist := TDictionary<integer,TList<Tpoint>>.create;

    n := 0;
    Randomize;

    img := TBitmap.Create;
    img.Width :=1000;
    img.Height :=1000;

    setlength(px,cells);
    setlength(py,cells);
    setlength(color,cells);

    for i:= 0 to cells-1 do
    begin
      px[i] := Random(size);
      py[i] := Random(size);

      color[i] := Random(16777215);
      auxList := TList<Tpoint>.Create;
      poligonlist.Add(i,auxList);
    end;

    for x := 0 to size - 1 do
    begin
      lastColor:= 0;
      for y := 0 to size - 1 do
      begin
        n:= 0;

        for i := 0 to cells - 1 do
        begin
          d1:= distance(px[i], x, py[i], y);
          d2:= distance(px[n], x, py[n], y);

          if d1 < d2 then
          begin
            n := i;
	  end;
        end;
        if n <> lastColor then
        begin
           poligonlist[n].Add(Point(x,y));
           poligonlist[lastColor].Add(Point(x,y));
           lastColor := n;
        end;
      end;

      poligonlist[n].Add(Point(x,y));
      poligonlist[lastColor].Add(Point(x,y));
      lastColor := n;
    end;

    for j := 0 to  cells -1 do
    begin

      SetLength(pointarray, poligonlist[j].Count);
      for I := 0 to poligonlist[j].Count - 1 do
      begin
        if Odd(i) then
        pointarray[i] := poligonlist[j].Items[i];
      end;
      for I := 0 to poligonlist[j].Count - 1 do
      begin
        if not Odd(i) then
        pointarray[i] := poligonlist[j].Items[i];
      end;
      Img.Canvas.Pen.Color := color[j];
      Img.Canvas.Brush.Color := color[j];
      Img.Canvas.Polygon(pointarray);

      Img.Canvas.Pen.Color := clBlack;
      Img.Canvas.Brush.Color := clBlack;
      Img.Canvas.Rectangle(px[j] -2, py[j] -2, px[j] +2, py[j] +2);
    end;
    Canvas.Draw(0,0, img);
end;
