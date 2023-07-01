unit main;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.ExtCtrls;

type
  TClock = class(TForm)
    tmrTimer: TTimer;
    procedure FormResize(Sender: TObject);
    procedure tmrTimerTimer(Sender: TObject);
  private
    { Private declarations }
    const
      degrees06 = PI / 30;
      degrees30 = degrees06 * 5;
      degrees90 = degrees30 * 3;
      margin = 20;
    var
      p0: TPoint;
      MinP0XY: Integer;
    class function IfThen(Condition: Boolean; TrueValue, FalseValue: Integer):
      Integer; overload; static;
    class function IfThen(Condition: Boolean; TrueValue, FalseValue: Double):
      Double; overload; static;
    procedure Paint; override;
    procedure DrawHand(Color: TColor; Angle, Size: Double; aWidth: Integer = 2);
    procedure DrawFace;
    procedure DrawCenter;
    procedure DrawNumbers(Angle: Double; Value: Integer);
  public
    { Public declarations }
  end;

var
  Clock: TClock;

implementation

{$R *.dfm}

{ TClock }

procedure TClock.DrawCenter;
var
  radius: Integer;
begin
  radius := 6;
  with Canvas do
  begin
    pen.Color := clNone;
    Brush.Color := clBlack;
    Ellipse(p0.x - radius, p0.y - radius, p0.x + radius, p0.y + radius);
  end;
end;

procedure TClock.DrawFace;
var
  radius, h, m: Integer;
begin
  radius := MinP0XY - margin;
  with Canvas do
  begin
    Pen.Color := clBlack;
    Pen.Width := 2;
    Brush.Color := clWhite;
    Ellipse(p0.x - radius, p0.y - radius, p0.x + radius, p0.y + radius);
    for m := 0 to 59 do
      DrawHand(clGray, m * degrees06, -0.08, 2);

    for h := 0 to 11 do
    begin
      DrawHand(clBlack, h * degrees30, -0.09, 3);
      DrawNumbers((h + 3) * degrees30, 12 - h);
    end;
  end;
end;

procedure TClock.DrawHand(Color: TColor; Angle, Size: Double; aWidth: Integer = 2);
var
  radius, x0, y0, x1, y1: Integer;
begin
  radius := MinP0XY - margin;

  x0 := p0.X + (IfThen(Size > 0, 0, Round(radius * (Size + 1) * cos(Angle))));
  y0 := p0.Y + (IfThen(Size > 0, 0, Round(radius * (Size + 1) * sin(-Angle))));

  x1 := p0.X + round(radius * IfThen(Size > 0, Size, 1) * cos(Angle));
  y1 := p0.y + round(radius * IfThen(Size > 0, Size, 1) * sin(-Angle));

  with Canvas do
  begin
    Pen.Color := Color;
    pen.Width := aWidth;
    MoveTo(x0, y0);
    LineTo(x1, y1);
  end;
end;

procedure TClock.DrawNumbers(Angle: Double; Value: Integer);
var
  radius, x0, y0, x1, y1, h, w: Integer;
  Size: Double;
  s: string;
begin
  radius := MinP0XY - margin;
  Size := 0.85;
  s := (Value).ToString;

  x1 := p0.X + round(radius * Size * cos(Angle));
  y1 := p0.y + round(radius * Size * sin(-Angle));

  with Canvas do
  begin
    radius := 5;
    Font.Size := 12;
    w := TextWidth(s);
    h := TextHeight(s);

    x0 := x1 - (w div 2);
    y0 := y1 - (h div 2);

    TextOut(x0, y0, s);
  end;
end;

procedure TClock.FormResize(Sender: TObject);
begin
  p0 := Tpoint.create(ClientRect.CenterPoint);
  MinP0XY := p0.x;
  if MinP0XY > p0.Y then
    MinP0XY := p0.y;
  Refresh();
end;

class function TClock.IfThen(Condition: Boolean; TrueValue, FalseValue: Double): Double;
begin
  if Condition then
    exit(TrueValue);
  exit(FalseValue);
end;

class function TClock.IfThen(Condition: Boolean; TrueValue, FalseValue: Integer): Integer;
begin
  if Condition then
    exit(TrueValue);
  exit(FalseValue);
end;

procedure TClock.Paint;
var
  t: TDateTime;
  second, minute, hour: Integer;
  angle, minsecs, hourmins: Double;
begin
  inherited;

  t := time;
  second := trunc(Frac(t * 24 * 60) * 60);
  minute := trunc(Frac(t * 24) * 60);
  hour := trunc(t * 24);

  DrawFace;

  angle := degrees90 - (degrees06 * second);
  DrawHand(clred, angle, 0.95, 3);

  minsecs := (minute + second / 60.0);

  angle := degrees90 - (degrees06 * minsecs);
  DrawHand(clGreen, angle, 0.8, 4);

  hourmins := (hour + minsecs / 60.0);
  angle := degrees90 - (degrees30 * hourmins);
  DrawHand(clBlue, angle, 0.6, 5);

  DrawCenter;

  Caption := Format('%.2d:%.2d:%.2d', [hour, minute, second]);
end;

procedure TClock.tmrTimerTimer(Sender: TObject);
begin
  Refresh;
end;

end.
