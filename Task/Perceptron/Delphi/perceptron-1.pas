unit main;

interface

uses
  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.ExtCtrls,
  System.UITypes;

type
  TTrainer = class
    inputs: TArray<Double>;
    answer: Integer;
    constructor Create(x, y: Double; a: Integer);
  end;

  TForm1 = class(TForm)
    tmr1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
  private
    procedure Perceptron(n: Integer);
    function FeedForward(inputs: Tarray<double>): integer;
    procedure Train(inputs: Tarray<double>; desired: integer);
  end;

var
  Form1: TForm1;
  Training: TArray<TTrainer>;
  weights: TArray<Double>;
  c: double = 0.00001;
  count: Integer = 0;

implementation

{$R *.dfm}

{ TTrainer }

constructor TTrainer.Create(x, y: Double; a: Integer);
begin
  inputs := [x, y, 1];
  answer := a;
end;

function f(x: double): double;
begin
  Result := x * 0.7 + 40;
end;

function activateFn(s: double): integer;
begin
  if (s > 0) then
    Result := 1
  else
    Result := -1;
end;

procedure TForm1.FormPaint(Sender: TObject);
const
  DotColor: array[Boolean] of TColor = (clRed, clBlue);
var
  i, x, y, guess: Integer;
begin
  with Canvas do
  begin
    Brush.Color := Tcolors.Whitesmoke;
    FillRect(ClipRect);

    x := ClientWidth;
    y := Trunc(f(x));
    Pen.Width := 3;
    pen.Color := TColors.Orange;
    Pen.Style := TPenStyle.psSolid;
    MoveTo(0, Trunc(f(0)));
    LineTo(x, y);
    Train(training[count].inputs, training[count].answer);
    count := (count + 1) mod length(training);

    Pen.Width := 1;
    pen.Color := TColors.Black;

    for i := 0 to count do
    begin
      guess := FeedForward(training[i].inputs);
      x := trunc(training[i].inputs[0] - 4);
      y := trunc(training[i].inputs[1] - 4);

      Brush.Style := TBrushStyle.bsSolid;
      Pen.Style := TPenStyle.psClear;

      Brush.Color := DotColor[guess > 0];
      Ellipse(rect(x, y, x + 8, y + 8));
    end;
  end;
end;

procedure TForm1.Perceptron(n: Integer);
const
  answers: array[Boolean] of integer = (-1, 1);
var
  i, x, y, answer: Integer;
begin
  SetLength(weights, n);
  for i := 0 to high(weights) do
    weights[i] := Random * 2 - 1;

  for i := 0 to High(Training) do
  begin
    x := Trunc(Random() * ClientWidth);
    y := Trunc(Random() * ClientHeight);

    answer := answers[y < f(x)];

    training[i] := TTrainer.Create(x, y, answer);
  end;
  tmr1.Enabled := true;
end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
  Invalidate;
end;

function TForm1.FeedForward(inputs: Tarray<double>): integer;
var
  sum: double;
  i: Integer;
begin
  Assert(length(inputs) = length(weights), 'weights and input length mismatch');
  sum := 0;
  for i := 0 to high(weights) do
    sum := sum + inputs[i] * weights[i];
  result := activateFn(sum);
end;

procedure TForm1.Train(inputs: Tarray<double>; desired: integer);
var
  guess: Integer;
  error: Double;
  i: Integer;
begin
  guess := FeedForward(inputs);
  error := desired - guess;
  for i := 0 to length(weights) - 1 do
    weights[i] := weights[i] + c * error * inputs[i];
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetLength(Training, 2000);
  Perceptron(3);
end;

end.
