program Padovan_sequence;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigDecimals,
  Boost.Generics.Collection;

type
  TpFn = TFunc<Integer, Integer>;

var
  RecMemo: TDictionary<Integer, Integer>;
  lSystemMemo: TDictionary<Integer, string>;

function pRec(n: Integer): Integer;
begin
  if RecMemo.HasKey(n) then
    exit(RecMemo[n]);

  if (n <= 2) then
    RecMemo[n] := 1
  else
    RecMemo[n] := pRec(n - 2) + pRec(n - 3);
  Result := RecMemo[n];
end;

function pFloor(n: Integer): Integer;
var
  p, s, a: BigDecimal;
begin
  p := '1.324717957244746025960908854';
  s := '1.0453567932525329623';
  a := p.IntPower(n - 1, 64);
  Result := Round(BigDecimal.Divide(a, s));
end;

function lSystem(n: Integer): string;
begin
  if n = 0 then
    lSystemMemo[n] := 'A'
  else
  begin
    lSystemMemo[n] := '';
    for var ch in lSystemMemo[n - 1] do
    begin
      case ch of
        'A':
          lSystemMemo[n] := lSystemMemo[n] + 'B';
        'B':
          lSystemMemo[n] := lSystemMemo[n] + 'C';
        'C':
          lSystemMemo[n] := lSystemMemo[n] + 'AB';
      end;
    end;
  end;
  Result := lSystemMemo[n];
end;

procedure Compare(f1, f2: TpFn; descr: string; stop: Integer);
begin
  write('The ', descr, ' functions ');
  var i := 0;
  while i < stop do
  begin
    var n1 := f1(i);
    var n2 := f2(i);
    if n1 <> n2 then
    begin
      write('do not match at ', i);
      writeln(': ', n1, ' != ', n2, '.');
      break;
    end;
    inc(i);
  end;
  if i = stop then
    writeln('match from P_0 to P_', stop, '.');
end;

begin
  RecMemo := TDictionary<Integer, Integer>.Create([], []);
  lSystemMemo := TDictionary<Integer, string>.Create([], []);

  write('P_0 .. P_19: ');
  for var i := 0 to 19 do
    write(pRec(i), ' ');
  writeln;

  Compare(pFloor, pRec, 'floor- and recurrence-based', 64);
  writeln(#10'The first 10 L-system strings are:');

  for var i := 0 to 9 do
    writeln(lSystem(i));
  writeln;

  Compare(pFloor,
    function(n: Integer): Integer
    begin
      Result := length(lSystem(n));
    end, 'floor- and L-system-based', 32);
  readln;
end.
