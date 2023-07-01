program I_before_E_except_after_C;

uses
  System.SysUtils, System.IOUtils;

function IsOppPlausibleWord(w: string): Boolean;
begin
  if ((not w.Contains('c')) and (w.Contains('ei'))) then
    exit(True);

  if (w.Contains('cie')) then
    exit(True);

  exit(false);
end;

function IsPlausibleWord(w: string): Boolean;
begin
  if ((not w.Contains('c')) and (w.Contains('ie'))) then
    exit(True);

  if (w.Contains('cie')) then
    exit(True);

  exit(false);
end;

function IsPlausibleRule(filename: TFileName): Boolean;
var
  words: TArray<string>;
  trueCount, falseCount: Cardinal;
  w: string;
begin
  words := TFile.ReadAllLines(filename, TEncoding.UTF8);
  trueCount := 0;
  falseCount := 0;

  for w in words do
  begin
    if (IsPlausibleWord(w)) then
      inc(trueCount)
    else if (IsOppPlausibleWord(w)) then
      inc(falseCount);

  end;

  Writeln('Plausible count: ', trueCount);
  Writeln('Implausible  count: ', falseCount);

  Result := trueCount > 2 * falseCount;;

end;

begin
  if (IsPlausibleRule('unixdict.txt')) then
    Writeln('Rule is plausible.')
  else
    Writeln('Rule is not plausible.');

end.
