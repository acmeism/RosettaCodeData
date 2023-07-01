unit SnakeGame;

interface

uses
  Winapi.Windows, System.SysUtils,
  System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Dialogs,
  System.Generics.Collections, Vcl.ExtCtrls;

type
  TSnakeApp = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DoFrameStep(Sender: TObject);
    procedure Reset;
  private
    { Private declarations }
    FrameTimer: TTimer;
  public
    { Public declarations }
  end;

  TSnake = class
    len: Integer;
    alive: Boolean;
    pos: TPoint;
    posArray: TList<TPoint>;
    dir: Byte;
  private
    function Eat(Fruit: TPoint): Boolean;
    function Overlap: Boolean;
    procedure update;
  public
    procedure Paint(Canvas: TCanvas);
    procedure Reset;
    constructor Create;
    destructor Destroy; override;
  end;

  TFruit = class
    FruitTime: Boolean;
    pos: TPoint;
    constructor Create;
    procedure Reset;
    procedure Paint(Canvas: TCanvas);
  private
    procedure SetFruit;
  end;

const
  L = 1;
  R = 2;
  D = 4;
  U = 8;

var
  SnakeApp: TSnakeApp;
  block: Integer = 24;
  wid: Integer = 30;
  hei: Integer = 20;
  fruit: TFruit;
  snake: TSnake;

implementation

{$R *.dfm}

function Rect(x, y, w, h: Integer): TRect;
begin
  Result := TRect.Create(x, y, x + w, y + h);
end;

{ TSnake }

constructor TSnake.Create;
begin
  posArray := TList<TPoint>.Create;
  Reset;
end;

procedure TSnake.Paint(Canvas: TCanvas);
var
  pos: TPoint;
  i, l: Integer;
  r: TRect;
begin
  with Canvas do
  begin
    Brush.Color := rgb(130, 190, 0);

    i := posArray.count - 1;
    l := posArray.count;
    while True do
    begin
      pos := posArray[i];
      dec(i);
      r := rect(pos.x * block, pos.y * block, block, block);
      FillRect(r);
      dec(l);
      if l = 0 then
        Break;
    end;
  end;
end;

procedure TSnake.Reset;
begin
  alive := true;
  pos := Tpoint.Create(1, 1);
  posArray.Clear;
  posArray.Add(Tpoint.Create(pos));
  len := posArray.Count;
  dir := r;
end;

destructor TSnake.Destroy;
begin
  posArray.Free;
  inherited;
end;

function TSnake.Eat(Fruit: TPoint): Boolean;
begin
  result := (pos.X = Fruit.X) and (pos.y = Fruit.y);
  if result then
  begin
    inc(len);
    if len > 5000 then
      len := 500;
  end;
end;

function TSnake.Overlap: Boolean;
var
  aLen: Integer;
  tp: TPoint;
  i: Integer;
begin
  aLen := posArray.count - 1;

  for i := 0 to aLen - 1 do
  begin
    tp := posArray[i];
    if (tp.x = pos.x) and (tp.y = pos.y) then
      Exit(True);
  end;
  Result := false;
end;

procedure TSnake.update;
begin
  if not alive then
    exit;
  case dir of
    l:
      begin
        dec(pos.X);
        if pos.X < 1 then
          pos.x := wid - 2
      end;
    r:
      begin
        inc(pos.x);
        if (pos.x > (wid - 2)) then
          pos.x := 1;
      end;
    U:
      begin
        dec(pos.y);

        if (pos.y < 1) then
          pos.y := hei - 2
      end;
    D:
      begin
        inc(pos.y);

        if (pos.y > hei - 2) then
          pos.y := 1;
      end;
  end;
  if Overlap then
    alive := False
  else
  begin
    posArray.Add(TPoint(pos));

    if len < posArray.Count then
      posArray.Delete(0);
  end;
end;

{ TFruit }

constructor TFruit.Create;
begin
  Reset;
end;

procedure TFruit.Paint(Canvas: TCanvas);
var
  r: TRect;
begin
  with Canvas do
  begin
    Brush.Color := rgb(200, 50, 20);

    r := Rect(pos.x * block, pos.y * block, block, block);

    FillRect(r);
  end;
end;

procedure TFruit.Reset;
begin
  fruitTime := true;
  pos := Tpoint.Create(0, 0);
end;

procedure TFruit.SetFruit;
begin
  pos.x := Trunc(Random(wid - 2) + 1);
  pos.y := Trunc(Random(hei - 2) + 1);
  fruitTime := false;
end;

procedure TSnakeApp.DoFrameStep(Sender: TObject);
begin
  Invalidate;
end;

procedure TSnakeApp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FrameTimer.Free;
  snake.Free;
  Fruit.Free;
end;

procedure TSnakeApp.FormCreate(Sender: TObject);
begin
  Canvas.pen.Style := psClear;
  ClientHeight := block * hei;
  ClientWidth := block * wid;
  DoubleBuffered := True;
  KeyPreview := True;

  OnClose := FormClose;
  OnKeyDown := FormKeyDown;
  OnPaint := FormPaint;

  snake := TSnake.Create;
  Fruit := TFruit.Create();
  FrameTimer := TTimer.Create(nil);
  FrameTimer.Interval := 250;
  FrameTimer.OnTimer := DoFrameStep;
  FrameTimer.Enabled := True;
end;

procedure TSnakeApp.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  function ValidDir(value: Byte): Byte;
  var
    combination: Byte;
  begin
    combination := (value or snake.dir);
    if (combination = 3) or (combination = 12) then
      Result := snake.dir
    else
      Result := value;
  end;

begin
  case Key of
    VK_LEFT:
      snake.dir := ValidDir(l);
    VK_RIGHT:
      snake.dir := ValidDir(r);
    VK_UP:
      snake.dir := ValidDir(U);
    VK_DOWN:
      snake.dir := ValidDir(D);
    VK_ESCAPE:
      Reset;
  end;
end;

procedure TSnakeApp.FormPaint(Sender: TObject);
var
  i: Integer;
  r: TRect;
  frameR: Double;
begin
  with Canvas do
  begin
    Brush.Color := rgb(0, $22, 0);
    FillRect(ClipRect);
    Brush.Color := rgb(20, 50, 120);

    for i := 0 to wid - 1 do
    begin
      r := rect(i * block, 0, block, block);
      FillRect(r);
      r := rect(i * block, ClientHeight - block, block, block);
      FillRect(r);
    end;

    for i := 1 to hei - 2 do
    begin
      r := Rect(1, i * block, block, block);
      FillRect(r);
      r := Rect(ClientWidth - block, i * block, block, block);
      FillRect(r);
    end;

    if (Fruit.fruitTime) then
    begin
      Fruit.setFruit();
      frameR := FrameTimer.Interval * 0.95;
      if frameR < 30 then
        frameR := 30;
      FrameTimer.Interval := trunc(frameR);
    end;

    Fruit.Paint(Canvas);
    snake.update();

    if not snake.alive then
    begin
      FrameTimer.Enabled := False;
      Application.ProcessMessages;
      ShowMessage('Game over');
      Reset;
      exit;
    end;

    if (snake.eat(Fruit.pos)) then
      Fruit.fruitTime := true;
    snake.Paint(Canvas);

    Brush.Style := bsClear;
    Font.Color := rgb(200, 200, 200);
    Font.Size := 18;
    TextOut(50, 0, (snake.len - 1).ToString);
  end;
end;

procedure TSnakeApp.Reset;
begin
  snake.Reset;
  Fruit.Reset;
  FrameTimer.Interval := 250;
  FrameTimer.Enabled := True;
end;
end.
