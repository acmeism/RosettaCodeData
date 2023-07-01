program Maybe_monad;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TmList = record
    Value: PInteger;
    function ToString: string;
    function Bind(f: TFunc<PInteger, TmList>): TmList;
  end;

function _Unit(aValue: Integer): TmList; overload;
begin
  Result.Value := GetMemory(sizeof(Integer));
  Result.Value^ := aValue;
end;

function _Unit(aValue: PInteger): TmList; overload;
begin
  Result.Value := aValue;
end;

{ TmList }

function TmList.Bind(f: TFunc<PInteger, TmList>): TmList;
begin
  Result := f(self.Value);
end;

function TmList.ToString: string;
begin
  if Value = nil then
    Result := 'none'
  else
    Result := value^.ToString;
end;

function Decrement(p: PInteger): TmList;
begin
  if p = nil then
    exit(_Unit(nil));
  Result := _Unit(p^ - 1);
end;

function Triple(p: PInteger): TmList;
begin
  if p = nil then
    exit(_Unit(nil));
  Result := _Unit(p^ * 3);
end;

var
  m1, m2: TmList;
  i, a, b, c: Integer;
  p: Tarray<PInteger>;

begin
  a := 3;
  b := 4;
  c := 5;
  p := [@a, @b, nil, @c];

  for i := 0 to High(p) do
  begin
    m1 := _Unit(p[i]);
    m2 := m1.Bind(Decrement).Bind(Triple);

    Writeln(m1.ToString: 4, ' -> ', m2.ToString);
  end;
  Readln;
end.
