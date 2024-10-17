unit main;

interface

uses
  Winapi.Windows, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.ExtCtrls,
  System.Generics.Collections;

type
  TColoredPoint = record
    P: TPoint;
    Index: Integer;
    constructor Create(PX, PY: Integer; ColorIndex: Integer);
  end;

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    Buffer: TBitmap;
    Points: array[0..2] of TPoint;
    Stack: TStack<TColoredPoint>;
    Tick: TTimer;
    procedure Run(Sender: TObject);
    procedure AddPoint;
    function HalfWayPoint(a: TColoredPoint; b: TPoint; index: Integer): TColoredPoint;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  Colors: array[0..2] of Tcolor = (clRed, clGreen, clBlue);

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TColoredPoint }

constructor TColoredPoint.Create(PX, PY: Integer; ColorIndex: Integer);
begin
  self.P := Tpoint.Create(PX, PY);
  self.Index := ColorIndex;
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Buffer := TBitmap.Create;
  Stack := TStack<TColoredPoint>.Create;
  Tick := TTimer.Create(nil);
  Caption := 'Chaos Game';

  DoubleBuffered := True;

  ClientHeight := 640;
  ClientWidth := 640;
  var margin := 60;
  var size := ClientWidth - 2 * margin;

  Points[0] := TPoint.Create(ClientWidth div 2, margin);
  Points[1] := TPoint.Create(margin, size);
  Points[2] := TPoint.Create(margin + size, size);

  Stack.Push(TColoredPoint.Create(-1, -1, Colors[0]));

  Tick.Interval := 10;
  Tick.OnTimer := Run;
end;

function TForm1.HalfWayPoint(a: TColoredPoint; b: TPoint; index: Integer): TColoredPoint;
begin
  Result := TColoredPoint.Create((a.p.X + b.x) div 2, (a.p.y + b.y) div 2, index);
end;

procedure TForm1.AddPoint;
begin
  var colorIndex := Random(3);
  var p1 := Stack.Peek;
  var p2 := Points[colorIndex];
  Stack.Push(HalfWayPoint(p1, p2, colorIndex));
end;

procedure TForm1.Run(Sender: TObject);
begin
  if Stack.Count < 50000 then
  begin
    for var i := 0 to 999 do
      AddPoint;
    Invalidate;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Tick.Free;
  Buffer.Free;
  Stack.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  for var p in Stack do
  begin
    with Canvas do
    begin
      Pen.Color := Colors[p.Index];
      Brush.Color := Colors[p.Index];
      Brush.Style := bsSolid;
      Ellipse(p.p.X - 1, p.p.y - 1, p.p.X + 1, p.p.y + 1);
    end;
  end;
end;
end.
