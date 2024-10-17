unit Main;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  end;

var
  Form1: TForm1;
  Points: TArray<TPoint>;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientHeight := 600;
  ClientWidth := 600;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  i: integer;
  p: TPoint;
  index: integer;
begin
  SetLength(Points, 404);
  i := 0;
  for var y := -15 to 15 do
    for var x := -15 to 15 do
    begin
      if i >= 404 then
        Break;
      var c := Sqrt(x * x + y * y);
      if (10 <= c) and (c <= 15) then
      begin
        inc(i);
        points[i] := TPoint.Create(x, y);
      end;
    end;
  var bm := TBitmap.create;
  bm.SetSize(600, 600);
  with bm.Canvas do
  begin
    Pen.Color := clRed;
    Brush.Color := clRed;
    Brush.Style := bsSolid;
    Randomize;

    for var count := 0 to 99 do
    begin
      repeat
        index := Random(404);
        p := points[index];
      until (not p.IsZero);
      points[index] := TPoint.Zero;

      var cx := 290 + 19 * p.X;
      var cy := 290 + 19 * p.Y;
      Ellipse(cx - 5, cy - 5, cx + 5, cy + 5);
    end;
  end;
  Canvas.Draw(0, 0, bm);
  bm.Free;
end;
end.
