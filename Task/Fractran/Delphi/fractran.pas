program FractranTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.RegularExpressions;

type
  TFractan = class
  private
    limit: Integer;
    num, den: TArray<Integer>;
    procedure compile(prog: string);
    procedure exec(val: Integer);
    function step(val: Integer): integer;
    procedure dump();
  public
    constructor Create(prog: string; val: Integer);
  end;

{ TFractan }

constructor TFractan.Create(prog: string; val: Integer);
begin
  limit := 15;
  compile(prog);
  dump();
  exec(2);
end;

procedure TFractan.compile(prog: string);
var
  reg: TRegEx;
  m: TMatch;
begin
  reg := TRegEx.Create('\s*(\d*)\s*\/\s*(\d*)\s*');
  m := reg.Match(prog);
  while m.Success do
  begin
    SetLength(num, Length(num) + 1);
    num[high(num)] := StrToIntDef(m.Groups[1].Value, 0);

    SetLength(den, Length(den) + 1);
    den[high(den)] := StrToIntDef(m.Groups[2].Value, 0);

    m := m.NextMatch;
  end;
end;

procedure TFractan.exec(val: Integer);
var
  n: Integer;
begin
  n := 0;
  while (n < limit) and (val <> -1) do
  begin
    Writeln(n, ': ', val);
    val := step(val);
    inc(n);
  end;
end;

function TFractan.step(val: Integer): integer;
var
  i: integer;
begin
  i := 0;
  while (i < length(den)) and (val mod den[i] <> 0) do
    inc(i);
  if i < length(den) then
    exit(round(num[i] * val / den[i]));
  result := -1;
end;

procedure TFractan.dump();
var
  i: Integer;
begin
  for i := 0 to high(den) do
    Write(num[i], '/', den[i], ' ');
  Writeln;
end;

const
  DATA =
    '17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1';

begin
  TFractan.Create(DATA, 2).Free;
  Readln;
end.
