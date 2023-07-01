unit Main;

interface

uses
    Winapi.Windows, Vcl.Graphics, Vcl.Forms, System.Math;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    procedure DrawPentagram(len, x, y: Integer; fill, stoke: TColor);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  degrees144: double;
  degrees72: double;
  degrees18: double;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientHeight := 640;
  ClientWidth := 640;
  degrees144 := DegToRad(144);
  degrees72 := DegToRad(72);
  degrees18 := DegToRad(18);
end;

procedure CreatePolygon(len, x, y, n: integer; ang: double; var points: TArray<TPoint>);
var
  angle: Double;
  index, i, x2, y2: Integer;
begin
  angle := 0;
  index := 0;
  SetLength(points, n + 1);
  points[index].Create(x, y);

  for i := 1 to n do
  begin
    x2 := x + round(len * cos(angle));
    y2 := y + round(len * sin(-angle));
    x := x2;
    y := y2;
    angle := angle - ang;

    points[index].Create(x2, y2);
    inc(index);
  end;
  points[index].Create(points[0]);
end;

procedure TForm1.DrawPentagram(len, x, y: Integer; fill, stoke: TColor);
var
  points, points_internal: TArray<TPoint>;
  L, H: Integer;
begin
  // Calc of sides for draw internal pollygon
  // 2H+L = len -> 2H = len - L
  // L = 2H*sin(36/2) (Pythagorean theorem)
  // L = (len-L)sin(18)
  // L = len*sin(18)/[1+sin(18)]

  L := round(len * sin(degrees18) / (1 + sin(degrees18)));

  // H = (len - L)/2

  H := (len - L) div 2;

  CreatePolygon(L, x + H, y, 5, degrees72, points_internal);
  CreatePolygon(len, x, y, 5, degrees144, points);

  with Canvas, Canvas.Brush do
  begin
    with pen do
    begin
      Color := stoke;
      Style := psSolid;
      Width := 5;
    end;
    Color := fill;
    Polygon(points_internal);
    Polygon(points);
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  with Canvas, Brush do
  begin
    Style := bsSolid;
    Color := clWhite;
    // fill background with white
    FillRect(ClientRect);
  end;
  drawPentagram(500, 70, 250, $ED9564, clDkGray);
end;

end.
