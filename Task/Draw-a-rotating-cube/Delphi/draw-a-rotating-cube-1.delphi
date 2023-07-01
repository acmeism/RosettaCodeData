unit main;

interface

uses
  Winapi.Windows, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls,
  System.Math, System.Classes;

type
  TForm1 = class(TForm)
    tmr1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  nodes: TArray<TArray<double>> = [[-1, -1, -1], [-1, -1, 1], [-1, 1, -1], [-1,
    1, 1], [1, -1, -1], [1, -1, 1], [1, 1, -1], [1, 1, 1]];
  edges: TArray<TArray<Integer>> = [[0, 1], [1, 3], [3, 2], [2, 0], [4, 5], [5,
    7], [7, 6], [6, 4], [0, 4], [1, 5], [2, 6], [3, 7]];

implementation

{$R *.dfm}

procedure Scale(factor: TArray<double>);
begin
  if Length(factor) <> 3 then
    exit;
  for var i := 0 to High(nodes) do
    for var f := 0 to High(factor) do
      nodes[i][f] := nodes[i][f] * factor[f];
end;

procedure RotateCuboid(angleX, angleY: double);
begin
  var sinX := sin(angleX);
  var cosX := cos(angleX);
  var sinY := sin(angleY);
  var cosY := cos(angleY);

  for var i := 0 to High(nodes) do
  begin
    var x := nodes[i][0];
    var y := nodes[i][1];
    var z := nodes[i][2];

    nodes[i][0] := x * cosX - z * sinX;
    nodes[i][2] := z * cosX + x * sinX;

    z := nodes[i][2];

    nodes[i][1] := y * cosY - z * sinY;
    nodes[i][2] := z * cosY + y * sinY;
  end;
end;

function DrawCuboid(x, y, w, h: Integer): TBitmap;
var
  offset: TPoint;
begin
  Result := TBitmap.Create;
  Result.SetSize(w, h);
  rotateCuboid(PI / 180, 0);
  offset := TPoint.Create(x, y);
  with Result.canvas do
  begin
    Brush.Color := clBlack;
    Pen.Color := clWhite;

    Lock;
    FillRect(ClipRect);

    for var edge in edges do
    begin
      var p1 := (nodes[edge[0]]);
      var p2 := (nodes[edge[1]]);
      moveTo(trunc(p1[0]) + offset.x, trunc(p1[1]) + offset.y);
      lineTo(trunc(p2[0]) + offset.x, trunc(p2[1]) + offset.y);
    end;
    Unlock;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientHeight := 360;
  ClientWidth := 640;
  DoubleBuffered := true;
  scale([100, 100, 100]);
  rotateCuboid(PI / 4, ArcTan(sqrt(2)));
end;

procedure TForm1.tmr1Timer(Sender: TObject);
var
  buffer: TBitmap;
begin
  buffer := DrawCuboid(ClientWidth div 2, ClientHeight div 2, ClientWidth, ClientHeight);
  Canvas.Draw(0, 0, buffer);
  buffer.Free;
end;

end.
