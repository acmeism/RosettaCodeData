program Biorhythms;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math;

var
  cycles: array[0..2] of string = ('Physical day ', 'Emotional day', 'Mental day   ');
  lengths: array[0..2] of Integer = (23, 28, 33);
  quadrants: array[0..3] of array[0..1] of string = (('up and rising', 'peak'),
    ('up but falling', 'transition'), ('down and falling', 'valley'), ('down but rising',
    'transition'));
  datePairs: array[0..2] of array[0..1] of string = (('1943-03-09', '1972-07-11'),
    ('1809-01-12', '1863-11-19'), ('1809-02-12', '1863-11-19') // correct DOB for Abraham Lincoln
    );

procedure Check(err: string);
begin
  if not err.IsEmpty then
    raise Exception.Create(err);
end;

function ParseDate(sDate: string; var Date: TDateTime): string;
var
  dtFormat: TFormatSettings;
begin
  Result := '';
  with dtFormat do
  begin
    DateSeparator := '-';
    ShortDateFormat := 'yyyy-mm-dd';
  end;

  try
    Date := StrtoDateTime(sDate, dtFormat);
  except
    on E: Exception do
      Result := E.Message;
  end;
end;

function DateToStr(dt: TDateTime): string;
var
  dtFormat: TFormatSettings;
begin
  Result := '';
  with dtFormat do
  begin
    DateSeparator := '-';
    ShortDateFormat := 'yyyy-mm-dd';
  end;
  Result := DateTimeToStr(dt, dtFormat);
end;

// Parameters assumed to be in YYYY-MM-DD format.
procedure CalcBiorhythms(birthDate, targetDate: string);
var
  bd, td: TDateTime;
  days: Integer;
begin
  Check(ParseDate(birthDate, bd));
  Check(ParseDate(targetDate, td));
  days := Trunc(td - bd);
  writeln('Born ', birthDate, ', Target ', targetDate);
  Writeln('Days ', days);
  for var i := 0 to 2 do
  begin
    var len := lengths[i];
    var cycle := cycles[i];
    var position := days mod len;
    var quadrant: Integer := trunc(position * 4 / len);
    var percent := sin(2.0 * PI * position / len);

    percent := floor(percent * 1000) / 10;
    var descript := '';
    if percent > 95 then
      descript := ' peak'
    else if percent < -95 then
      descript := ' valley'
    else if abs(percent) < 5 then
      descript := ' critical transition'
    else
    begin
      var daysToAdd := trunc((quadrant + 1) * len / 4 - position);
      var transition := td + daysToAdd;
      var trend := quadrants[quadrant, 0];
      var next := quadrants[quadrant, 1];
      var transStr := DateToStr(transition);
      var percentRounded := percent;
      descript := format('%5.3f%% (%s, next %s %s)', [percentRounded, trend,
        next, transStr]);
    end;
    writeln(format('%s %2d : %s', [cycle, position, descript]));
  end;
  writeln;
end;

begin
  for var i := 0 to High(datePairs) do
    CalcBiorhythms(datePairs[i, 0], datePairs[i, 1]);
  readln;
end.
