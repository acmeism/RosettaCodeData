unit main;

interface

uses
  Vcl.Forms, Vcl.Graphics, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Timer: TTimer;
    angle, angleAccel, angleVelocity, dt: double;
    len: Integer;
    procedure Tick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Width := 200;
  Height := 200;
  DoubleBuffered := True;
  Timer := TTimer.Create(nil);
  Timer.Interval := 30;
  Timer.OnTimer := Tick;
  Caption := 'Pendulum';

  // initialize
  angle := PI / 2;
  angleAccel := 0;
  angleVelocity := 0;
  dt := 0.1;
  len := 50;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Timer.Free;
end;

procedure TForm1.Tick(Sender: TObject);
const
  HalfPivot = 4;
  HalfBall = 7;
var
  anchorX, anchorY, ballX, ballY: Integer;
begin
  anchorX := Width div 2 - 12;
  anchorY := Height div 4;
  ballX := anchorX + Trunc(Sin(angle) * len);
  ballY := anchorY + Trunc(Cos(angle) * len);

  angleAccel := -9.81 / len * Sin(angle);
  angleVelocity := angleVelocity + angleAccel * dt;
  angle := angle + angleVelocity * dt;

  with canvas do
  begin
    Pen.Color := clBlack;

    with Brush do
    begin
      Style := bsSolid;
      Color := clWhite;
    end;

    FillRect(ClientRect);
    MoveTo(anchorX, anchorY);
    LineTo(ballX, ballY);

    Brush.Color := clGray;
    Ellipse(anchorX - HalfPivot, anchorY - HalfPivot, anchorX + HalfPivot,
      anchorY + HalfPivot);

    Brush.Color := clYellow;
    Ellipse(ballX - HalfBall, ballY - HalfBall, ballX + HalfBall, ballY + HalfBall);
  end;
end;

end.
