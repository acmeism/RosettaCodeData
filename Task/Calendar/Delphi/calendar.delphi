program Calendar;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.DateUtils;

function Center(s: string; width: Integer): string;
var
  side: Integer;
begin
  if s.Length >= width then
    exit(s);
  side := (width - s.Length) div 2;
  Result := s + string.Create(' ', side);
  Result := string.Create(' ', width - Result.Length) + Result;
end;

procedure PrintCalendar(year, nCols: word; local: string = 'en-US');
var
  fmt: TFormatSettings;
begin
  if (nCols <= 0) or (nCols > 12) then
    exit;
  fmt := TFormatSettings.Create(local);
  var rows := 12 div nCols + ord(12 mod nCols <> 0);
  var date := EncodeDate(year, 1, 1);
  var offs := DayOfTheWeek(date);

  var months: TArray<string>;
  setlength(months, 12);
  for var i := 1 to 12 do
    months[i - 1] := fmt.LongMonthNames[i];

  var sWeek := '';
  for var i := 1 to 7 do
    sWeek := sWeek + ' ' + copy(fmt.ShortDayNames[i], 1, 2);

  var mons: TArray<TArray<string>>;
  SetLength(mons, 12, 8);
  for var m := 0 to 11 do
  begin
    mons[m, 0] := Center(months[m], 21);
    mons[m, 1] := sWeek;
    var dim := DaysInMonth(date);
    for var d := 1 to 43 do
    begin
      var day := (d > offs) and (d <= offs + dim);
      var str := '   ';
      if day then
        str := format(' %2d', [d - offs]);
      mons[m, 2 + (d - 1) div 7] := mons[m, 2 + (d - 1) div 7] + str;
    end;
    offs := (offs + dim) mod 7;
    date := IncMonth(date, 1);
  end;
  writeln(Center('[Snoopy Picture]', nCols * 24 + 4));
  Writeln(Center(year.ToString, nCols * 24 + 4));
  writeln;

  for var r := 0 to rows - 1 do
  begin
    var s: TArray<string>;
    SetLength(s, 8);
    for var c := 0 to nCols - 1 do
    begin
      if r * nCols + c > 11 then
        Break;
      for var i := 0 to High(mons[r * nCols + c]) do
      begin
        var line := mons[r * nCols + c, i];
        s[i] := s[i] + '   ' + line;
      end;
    end;

    for var ss in s do
    begin
      writeln(ss, ' ');
    end;
    writeln;
  end;

end;

begin
  printCalendar(1969, 4);
  readln;
end.
