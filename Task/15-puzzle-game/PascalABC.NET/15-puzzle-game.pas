// Игра в 15 PABCWork.NET\Samples\Games\15.pas
uses GraphABC,ABCObjects,ABCButtons;

const
/// размер поля
  n = 4;
/// размер фишки
  sz = 100;
/// зазор между фишками
  zz = 10;
/// отступ от левого и правого краев
  x0 = 20;
/// отступ от верхнего и нижнего краев
  y0 = 20;

var
  p: array [1..n,1..n] of SquareABC;
  digits: array [1..n*n-1] of integer;

  MeshButton: ButtonABC;
  StatusRect: RectangleABC;

  EmptyCellX,EmptyCellY: integer;
  MovesCount: integer;
  EndOfGame: boolean;  // True если все фишки стоят на своих местах

// Поменять местами две фишки
procedure Swap(var p,p1: SquareABC);
begin
  PABCSystem.Swap(p,p1);
  var i := p.Left;
  p.Left := p1.Left;
  p1.Left := i;
  i := p.Top;
  p.Top := p1.Top;
  p1.Top := i;
end;

// Определить, являются ли клетки соседями
function Neighbours(x1,y1,x2,y2: integer): boolean;
begin
  Result := (Abs(x1-x2)=1) and (y1=y2) or (Abs(y1-y2)=1) and (x1=x2)
end;

// Заполнить вспомогательный массив цифр
procedure FillDigitsArr;
begin
  for var i:=1 to n*n-1 do
    digits[i] := i;
end;

// Перемешать вспомогательный массив цифр. Количество обменов должно быть четным
procedure MixDigitsArr;
var x: integer;
begin
  for var i:=1 to n*n-1 do
  begin
    repeat
      x := Random(15)+1;
    until x<>i;
    Swap(digits[i],digits[x]);
  end;
  if n mod 2=0 then
    Swap(digits[1],digits[2]); // количество обменов должно быть четным
end;

// Заполнить двумерный массив фишек. Вместо пустой ячейки - белая фишка с числом 0
procedure Fill15ByDigitsArr;
begin
  Swap(p[EmptyCellY,EmptyCellX],p[n,n]); // Переместить пустую фишку в правый нижний угол
  EmptyCellX := n;
  EmptyCellY := n;
  var i := 1;
  for var y:=1 to n do
  for var x:=1 to n do
  begin
    if x*y=n*n then exit;
    p[y,x].Number := digits[i];
    i += 1;
  end;
end;

// Перемешать массив фишек
procedure Mix15;
begin
  MixDigitsArr;
  Fill15ByDigitsArr;
  MovesCount := 0;
  EndOfGame := False;
  StatusRect.Text := 'Количество ходов: '+IntToStr(MovesCount);
  StatusRect.Color := RGB(200,200,255);
end;

// Создать массив фишек
procedure Create15;
begin
  EmptyCellX := n;
  EmptyCellY := n;
  for var x:=1 to n do
  for var y:=1 to n do
  begin
    p[y,x] := new SquareABC(x0+(x-1)*(sz+zz),y0+(y-1)*(sz+zz),sz,clMoneyGreen);
    p[y,x].BorderColor := clGreen;
    p[y,x].BorderWidth := 2;
    p[y,x].TextScale := 0.7;
  end;
  p[EmptyCellY,EmptyCellX].Color := clWhite;
  p[EmptyCellY,EmptyCellX].BorderColor := clWhite;
  FillDigitsArr;
  MixDigitsArr;
  Fill15ByDigitsArr;
end;

// Проверить, все ли фишки стоят на своих местах
function IsSolution: boolean;
begin
  Result:=True;
  var i:=1;
  for var y:=1 to n do
  for var x:=1 to n do
  begin
    if p[y,x].Number<>i then
    begin
      Result:=False;
      break;
    end;
    i += 1;
    if i=n*n then i:=0;
  end;
end;

procedure MouseDown(x,y,mb: integer);
begin
  if EndOfGame then // Если все фишки на своих местах, то не реагировать на мышь и ждать нажатия кнопки "Перемешать"
    exit;
  if ObjectUnderPoint(x,y)=nil then // Eсли мы щелкнули не на объекте, то не реагировать на мышь
    exit;
  var fx := (x-x0) div (sz+zz) + 1; // Вычислить координаты на доске для ячейки, на которой мы щелкнули мышью
  var fy := (y-y0) div (sz+zz) + 1;
  if (fx>n) or (fy>n) then
    exit;
  if Neighbours(fx,fy,EmptyCellX,EmptyCellY) then // Если ячейка соседствует с пустой, то поменять их местами
  begin
    Swap(p[EmptyCellY,EmptyCellX],p[fy,fx]);
    EmptyCellX := fx;
    EmptyCellY := fy;
    Inc(MovesCount);
    StatusRect.Text := 'Количество ходов: ' + MovesCount;
    if IsSolution then
    begin
      StatusRect.Text := 'Победа! Сделано ходов: ' + MovesCount;
      StatusRect.Color := RGB(255,200,200);
      EndOfGame := True;
    end
  end;
end;

begin
  SetSmoothingOff;
  Window.Title := 'Игра в 15';
  Window.IsFixedSize := True;
  SetWindowSize(2*x0+(sz+zz)*n-zz,2*y0+(sz+zz)*n-zz+90);

  EndOfGame := False;
  Create15;

  MeshButton := ButtonABC.Create((WindowWidth-200) div 2,2*y0+(sz+zz)*n-zz,200,'Перемешать',clLightGray);
  MeshButton.OnClick := Mix15;
  StatusRect := new RectangleABC(0,WindowHeight-40,WindowWidth,40,RGB(200,200,255));
  StatusRect.TextVisible := True;
  StatusRect.Text := 'Количество ходов: '+IntToStr(MovesCount);
  StatusRect.BorderWidth := 2;
  StatusRect.BorderColor := RGB(80,80,255);

  MovesCount := 0;

  OnMouseDown := MouseDown;
end.
