program ChemicalCalculator;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections;

{$I AtomicMass.inc }

type
  TAtomicMass = class(TDictionary<string, Double>)
  public
    constructor Create(Keys: array of string; Values: array of Double); overload;
  end;

{ TAtomicMass }

constructor TAtomicMass.Create(Keys: array of string; Values: array of Double);
var
  i: Integer;
begin
  inherited Create;

  Assert(length(Keys) = Length(Values), 'Keys and values must have the same size');
  if Length(Keys) = 0 then
    exit;

  for i := 0 to High(Keys) do
    Add(Keys[i], Values[i]);
end;

var
  AtomicMassData: TAtomicMass;

function Evaluate(s: string): Double;
var
  sum: Double;
  symbol: string;
  number: string;
  c: char;
  i, n: Integer;
begin
  s := s + '[';
  symbol := '';
  number := '';

  for i := 1 to s.Length do
  begin
    c := s[i];
    if ('@' <= c) and (c <= '[') then
    begin
      n := 1;
      if not number.IsEmpty then
        n := StrToInt(number);
      if not symbol.IsEmpty then
        sum := sum + AtomicMassData[symbol] * n;
      if c = '[' then
        Break;
      symbol := c;
      number := '';
      Continue;
    end;

    if ('a' <= c) and (c <= 'z') then
    begin
      symbol := symbol + c;
      Continue;
    end;

    if ('0' <= c) and (c <= '9') then
    begin
      number := number + c;
      Continue;
    end;

    raise Exception.Create('Unexpected symbol ' + c + ' in molecule');
  end;
  Result := sum;
end;

function ReplaceFirst(text, search, replace: string): string;
var
  pos: Integer;
begin
  pos := text.IndexOf(search);
  if (pos < 0) then
    Exit(text);
  Result := text.Substring(0, pos) + replace + text.Substring(pos + search.Length);
end;

function ReplaceParens(s: string): string;
var
  letter: Char;
  start: Integer;
  i: Integer;
  expr, symbol: string;
begin
  letter := 's';
  while True do
  begin
    start := s.IndexOf('(');
    if (start = -1) then
      Break;

    for i := start + 1 to s.Length - 1 do
    begin
      if s[i + 1] = ')' then
      begin
        expr := s.Substring(start + 1, i - start - 1);
        symbol := '@' + letter;
        s := ReplaceFirst(s, s.Substring(start, i + 1 - start), symbol);
        if not (AtomicMassData.ContainsKey(symbol)) then
          AtomicMassData.Add(symbol, Evaluate(expr))
        else
          AtomicMassData[symbol] := Evaluate(expr);
        inc(letter);
        Break;
      end;

      if (s[i + 1] = '(') then
        start := i;
    end;
  end;
  Result := s;
end;


var
  molecules: array of string;
  i: Integer;
  mass: Double;

begin
  molecules := ['H', 'H2', 'H2O', 'H2O2', '(HO)2', 'Na2SO4', 'C6H12',
    'COOH(C(CH3)2)3CH3', 'C6H4O2(OH)4', 'C27H46O', 'Uue'];
  AtomicMassData := TAtomicMass.Create(ATOMIC_MASS_SYMBOL, ATOMIC_MASS_VALUE);

  for i := 0 to 10 do
  begin
    mass := Evaluate(ReplaceParens(molecules[i]));
    Writeln(format('%17s -> %7s', [molecules[i], FormatFloat('####.000',mass)]));
  end;

  AtomicMassData.Free;
  readln;
end.
