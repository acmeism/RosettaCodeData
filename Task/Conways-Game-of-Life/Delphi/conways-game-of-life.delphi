program game_of_life;

{$APPTYPE CONSOLE}



uses
  System.SysUtils,
  Velthuis.Console; // CrlScr

type
  TBoolMatrix = TArray<TArray<Boolean>>;

  TField = record
    s: TBoolMatrix;
    w, h: Integer;
    procedure SetValue(x, y: Integer; b: boolean);
    function Next(x, y: Integer): boolean;
    function State(x, y: Integer): boolean;
    class function NewField(w1, h1: Integer): TField; static;
  end;

  TLife = record
    a, b: TField;
    w, h: Integer;
    class function NewLife(w1, h1: Integer): TLife; static;
    procedure Step;
    function ToString: string;
  end;

{ TField }

class function TField.NewField(w1, h1: Integer): TField;
var
  s1: TBoolMatrix;
begin
  SetLength(s1, h1);
  for var i := 0 to High(s1) do
    SetLength(s1[i], w1);
  with Result do
  begin
    s := s1;
    w := w1;
    h := h1;
  end;
end;

function TField.Next(x, y: Integer): boolean;
var
  _on: Integer;
begin
  _on := 0;
  for var i := -1 to 1 do
    for var j := -1 to 1 do
      if self.State(x + i, y + j) and not ((j = 0) and (i = 0)) then
        inc(_on);
  Result := (_on = 3) or (_on = 2) and self.State(x, y);
end;

procedure TField.SetValue(x, y: Integer; b: boolean);
begin
  self.s[y, x] := b;
end;

function TField.State(x, y: Integer): boolean;
begin
  while y < 0 do
    inc(y, self.h);
  while x < 0 do
    inc(x, self.w);
  result := self.s[y mod self.h, x mod self.w]
end;

{ TLife }

class function TLife.NewLife(w1, h1: Integer): TLife;
var
  a1: TField;
begin
  a1 := TField.NewField(w1, h1);
  for var i := 0 to (w1 * h1 div 2) do
    a1.SetValue(Random(w1), Random(h1), True);
  with Result do
  begin
    a := a1;
    b := TField.NewField(w1, h1);
    w := w1;
    h := h1;
  end;
end;

procedure TLife.Step;
var
  tmp: TField;
begin
  for var y := 0 to self.h - 1 do
    for var x := 0 to self.w - 1 do
      self.b.SetValue(x, y, self.a.Next(x, y));
  tmp := self.a;
  self.a := self.b;
  self.b := tmp;
end;

function TLife.ToString: string;
begin
  result := '';
  for var y := 0 to self.h - 1 do
  begin
    for var x := 0 to self.w - 1 do
    begin
      var b: char := ' ';
      if self.a.State(x, y) then
        b := '*';
      result := result + b;
    end;
    result := result + #10;
  end;
end;

begin
  Randomize;

  var life := TLife.NewLife(80, 15);

  for var i := 1 to 300 do
  begin
    life.Step;
    ClrScr;
    writeln(life.ToString);
    sleep(30);
  end;
  readln;
end.
