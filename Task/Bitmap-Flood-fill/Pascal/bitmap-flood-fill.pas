program FloodFillTest;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Winapi.Windows,
  System.SysUtils,
  System.Generics.Collections,
  vcl.Graphics;

procedure FloodFill(bmp: tBitmap; pt: TPoint; targetColor: TColor;
  replacementColor: TColor);
var
  q: TQueue<TPoint>;
  n, w, e: TPoint;
begin
  q := TQueue<TPoint>.Create;

  q.Enqueue(pt);

  while (q.Count > 0) do
  begin
    n := q.Dequeue;
    if bmp.Canvas.Pixels[n.X, n.Y] <> targetColor then
      Continue;

    w := n;
    e := TPoint.Create(n.X + 1, n.Y);

    while ((w.X >= 0) and (bmp.Canvas.Pixels[w.X, w.Y] = targetColor)) do
    begin
      bmp.Canvas.Pixels[w.X, w.Y] := replacementColor;
      if ((w.Y > 0) and (bmp.Canvas.Pixels[w.X, w.Y - 1] = targetColor)) then
        q.Enqueue(TPoint.Create(w.X, w.Y - 1));
      if ((w.Y < bmp.Height - 1) and (bmp.Canvas.Pixels[w.X, w.Y + 1] = targetColor)) then
        q.Enqueue(TPoint.Create(w.X, w.Y + 1));
      dec(w.X);
    end;

    while ((e.X <= bmp.Width - 1) and (bmp.Canvas.Pixels[e.X, e.Y] = targetColor)) do
    begin
      bmp.Canvas.Pixels[e.X, e.Y] := replacementColor;
      if ((e.Y > 0) and (bmp.Canvas.Pixels[e.X, e.Y - 1] = targetColor)) then
        q.Enqueue(TPoint.Create(e.X, e.Y - 1));

      if ((e.Y < bmp.Height - 1) and (bmp.Canvas.Pixels[e.X, e.Y + 1] = targetColor)) then
        q.Enqueue(TPoint.Create(e.X, e.Y + 1));
      inc(e.X);
    end;
  end;
  q.Free;
end;

var
  bmp: TBitmap;

begin
  bmp := TBitmap.Create;
  try
    bmp.LoadFromFile('Unfilledcirc.bmp');
    FloodFill(bmp, TPoint.Create(200, 200), clWhite, clRed);
    FloodFill(bmp, TPoint.Create(100, 100), clBlack, clBlue);
    bmp.SaveToFile('Filledcirc.bmp');
  finally
    bmp.Free;
  end;

end.
