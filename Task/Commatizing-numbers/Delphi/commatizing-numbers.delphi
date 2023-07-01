program Commatizing_numbers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.RegularExpressions,
  system.StrUtils;

const
  PATTERN = '(\.[0-9]+|[1-9]([0-9]+)?(\.[0-9]+)?)';
  TESTS: array[0..13] of string = ('123456789.123456789', '.123456789',
    '57256.1D-4', 'pi=3.14159265358979323846264338327950288419716939937510582097494459231',
    'The author has two Z$100000000000000 Zimbabwe notes (100 trillion).',
    '-in Aus$+1411.8millions', '===US$0017440 millions=== (in 2000 dollars)',
    '123.e8000 is pretty big.',
    'The land area of the earth is 57268900(29% of the surface) square miles.',
    'Ain''t no numbers in this here words, nohow, no way, Jose.',
    'James was never known as 0000000007',
    'Arthur Eddington wrote: I believe there are ' +
    '15747724136275002577605653961181555468044717914527116709366231425076185631031296' +
    ' protons in the universe.', '   $-140000±100 millions.',
    '6/9/1946 was a good year for some.');

var
  regex: TRegEx;

function Commatize(s: string; startIndex, period: integer; sep: string): string;
var
  m: TMatch;
  s1, ip, pi, dp: string;
  splits: TArray<string>;
  i: integer;
begin
  regex := TRegEx.Create(PATTERN);

  if (startIndex < 0) or (startIndex >= s.Length) or (period < 1) or (sep.IsEmpty) then
    exit(s);
  m := regex.Match(s.Substring(startIndex, s.Length));
  if not m.Success then
    exit(s);

  s1 := m.Groups[0].Value;
  splits := s1.Split(['.']);

  ip := splits[0];

  if ip.Length > period then
  begin
    pi := ReverseString(ip);
    i := ((ip.Length - 1) div period) * period;

    while i >= period do
    begin
      pi := pi.Substring(0, i) + sep + pi.Substring(i);
      i := i - period;
    end;
    ip := ReverseString(pi);
  end;

  if s1.Contains('.') then
  begin
    dp := splits[1];
    if dp.Length > period then
    begin
      i := ((dp.Length - 1) div period) * period;
      while i >= period do
      begin
        dp := dp.Substring(0, i) + sep + dp.Substring(i);
        i := i - period;
      end;
    end;
    ip := ip + '.' + dp;
  end;
  Result := s.Substring(0, startIndex) + s.Substring(startIndex).Replace(s1, ip, []);
end;

var
  i: integer;

begin
  Writeln(commatize(TESTS[0], 0, 2, '*'));
  Writeln(commatize(TESTS[1], 0, 3, '-'));
  Writeln(commatize(TESTS[2], 0, 4, '__'));
  Writeln(commatize(TESTS[3], 0, 5, ' '));
  Writeln(commatize(TESTS[4], 0, 3, '.'));
  for i := 5 to High(TESTS) do
    Writeln(commatize(TESTS[i], 0, 3, ','));
  readln;
end.
