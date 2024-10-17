unit uMain;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    tmr1: TTimer;
    lblPosition: TLabel;
    procedure tmr1Timer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DrawCrosshair(X, Y: Integer);
  end;

var
  Form1: TForm1;
  X: Integer = 0;
  Y: Integer = 0;

implementation

uses
  mmSystem, Vcl.Graphics;

{$R *.dfm}

procedure TForm1.DrawCrosshair(X, Y: Integer);
const
  RADIUS = 10;
  CROSS = 3;
begin
  Canvas.Brush.Color := clblack;
  Canvas.FillRect(ClientRect);
  with Canvas do
  begin
    Pen.Color := clWhite;
    pen.Width := 1;
    Ellipse(X - RADIUS, Y - RADIUS, X + RADIUS, Y + RADIUS);
    pen.Width := 2;
    MoveTo(X - CROSS * RADIUS, Y);
    LineTo(X + CROSS * RADIUS, Y);
    MoveTo(X, Y - CROSS * RADIUS);
    LineTo(X, Y + CROSS * RADIUS);
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  DrawCrosshair(X, Y);
end;

procedure TForm1.tmr1Timer(Sender: TObject);
var
  info: TJoyInfo;
begin
  if (joyGetPos(0, @info) = 0) then
  begin
    X := Round(ClientWidth * info.wXpos / MAXWORD);
    Y := Round(ClientHeight * info.wYpos / MAXWORD);
    lblPosition.Caption := Format('(%3d,%3d)', [X, Y]);
    Invalidate;
  end;
end;

end.
