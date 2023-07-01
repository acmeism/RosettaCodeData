program Dragon_curve;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics;

type
  TDragon = class
  private
    p: TColor;
    _sin: TArray<double>;
    _cos: TArray<double>;
    s: double;
    b: TBitmap;
    FAsBitmap: TBitmap;
    const
      sep = 512;
      depth = 14;
    procedure Dragon(n, a, t: Integer; d, x, y: Double; var b: TBitmap);
  public
    constructor Create;
    destructor Destroy; override;
    property AsBitmap: TBitmap read b;
  end;

{ TDragon }

procedure TDragon.Dragon(n, a, t: Integer; d, x, y: Double; var b: TBitmap);
begin
  if n <= 1 then
  begin
    with b.Canvas do
    begin
      Pen.Color := p;
      MoveTo(Trunc(x + 0.5), Trunc(y + 0.5));
      LineTo(Trunc(x + d * _cos[a] + 0.5), Trunc(y + d * _sin[a] + 0.5));
      exit;
    end;
  end;

  d := d * s;
  var a1 := (a - t) and 7;
  var a2 := (a + t) and 7;

  dragon(n - 1, a1, 1, d, x, y, b);
  dragon(n - 1, a2, -1, d, x + d * _cos[a1], y + d * _sin[a1], b);
end;

constructor TDragon.Create;
begin
  s := sqrt(2) / 2;
  _sin := [0, s, 1, s, 0, -s, -1, -s];
  _cos := [1.0, s, 0.0, -s, -1.0, -s, 0.0, s];
  p := Rgb(64, 192, 96);
  b := TBitmap.create;

  var width := Trunc(sep * 11 / 6);
  var height := Trunc(sep * 4 / 3);
  b.SetSize(width, height);
  with b.Canvas do
  begin
    Brush.Color := clWhite;
    Pen.Width := 3;
    FillRect(Rect(0, 0, width, height));
  end;
  dragon(14, 0, 1, sep, sep / 2, sep * 5 / 6, b);
end;

destructor TDragon.Destroy;
begin
  b.Free;
  inherited;
end;

var
  Dragon: TDragon;

begin
  Dragon := TDragon.Create;
  Dragon.AsBitmap.SaveToFile('dragon.bmp');
  Dragon.Free;
end.
