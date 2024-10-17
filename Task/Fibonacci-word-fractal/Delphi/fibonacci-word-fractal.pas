program Fibonacci_word;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Vcl.Graphics;

function GetWordFractal(n: Integer): string;
var
  f1, f2, tmp: string;
  i: Integer;
begin
  case n of
    0:
      Result := '';
    1:
      Result := '1';
  else
    begin
      f1 := '1';
      f2 := '0';

      for i := n - 2 downto 1 do
      begin
        tmp := f2;
        f2 := f2 + f1;
        f1 := tmp;
      end;

      Result := f2;
    end;
  end;
end;

procedure DrawWordFractal(n: Integer; g: TCanvas; x, y, dx, dy: integer);
var
  i, tx: Integer;
  wordFractal: string;
begin
  wordFractal := GetWordFractal(n);
  with g do
  begin
    Brush.Color := clWhite;
    FillRect(ClipRect);
    Pen.Color := clBlack;
    pen.Width := 1;
    MoveTo(x, y);
  end;
  for i := 1 to wordFractal.Length do
  begin
    g.LineTo(x + dx, y + dy);
    inc(x, dx);
    inc(y, dy);
    if wordFractal[i] = '0' then
    begin
      tx := dx;
      if Odd(i) then
      begin
        dx := dy;
        dy := -tx;
      end
      else
      begin
        dx := -dy;
        dy := tx;
      end;
    end;
  end;
end;

function WordFractal2Bitmap(n, x, y, width, height: Integer): TBitmap;
begin
  Result := TBitmap.Create;
  Result.SetSize(width, height);
  DrawWordFractal(n, Result.Canvas, x, height - y, 1, 0);
end;

begin
  with WordFractal2Bitmap(23, 20, 20, 450, 620) do
  begin
    SaveToFile('WordFractal.bmp');
    Free;
  end;
end.
