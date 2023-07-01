program Discordian_date;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.DateUtils;

type
  TDateTimeHelper = record helper for TDateTime
    const
      seasons: array of string = ['Chaos', 'Discord', 'Confusion', 'Bureaucracy',
        'The Aftermath'];
      weekday: array of string = ['Sweetmorn', 'Boomtime', 'Pungenday',
        'Prickle-Prickle', 'Setting Orange'];
      apostle: array of string = ['Mungday', 'Mojoday', 'Syaday', 'Zaraday', 'Maladay'];
      holiday: array of string = ['Chaoflux', 'Discoflux', 'Confuflux',
        'Bureflux', 'Afflux'];
    function DiscordianDate(): string;
  end;

{ TDateTimeHelper }

function TDateTimeHelper.DiscordianDate: string;
var
  isLeapYear: boolean;
begin
  isLeapYear := IsInLeapYear(self);
  var dYear := (YearOf(self) + 1166).ToString;
  if isLeapYear and (MonthOf(self) = 2) and (dayof(self) = 29) then
    exit('St. Tib''s Day, in the YOLD ' + dYear);

  var doy := DayOfTheYear(self);
  if isLeapYear and (doy >= 60) then
    doy := doy - 1;

  var dsDay := doy mod 73;

  if dsDay = 0 then
    dsDay := 73;

  if dsDay = 5 then
    exit(apostle[doy div 73] + ', in the YOLD ' + dYear);

  if dsDay = 50 then
    exit(holiday[doy div 73] + ', in the YOLD ' + dYear);

  var dSeas: string;

  if (doy mod 73) = 0 then
    dSeas := seasons[(doy - 1) div 73]
  else
    dSeas := seasons[doy div 73];

  var dWday := weekday[(doy - 1) mod 5];

  Result := format('%s, day %d of %s in the YOLD %s', [dWday, dsDay, dSeas, dYear]);

end;

procedure Test();
begin
  Assert(EncodeDate(2010, 7, 22).DiscordianDate =
    'Pungenday, day 57 of Confusion in the YOLD 3176');
  Assert(EncodeDate(2012, 2, 28).DiscordianDate =
    'Prickle-Prickle, day 59 of Chaos in the YOLD 3178');
  Assert(EncodeDate(2012, 2, 29).DiscordianDate = 'St. Tib''s Day, in the YOLD 3178');
  Assert(EncodeDate(2012, 3, 1).DiscordianDate =
    'Setting Orange, day 60 of Chaos in the YOLD 3178');
  Assert(EncodeDate(2010, 1, 5).DiscordianDate = 'Mungday, in the YOLD 3176');
  Assert(EncodeDate(2011, 5, 3).DiscordianDate = 'Discoflux, in the YOLD 3177');
  writeln('OK');
end;

var
  dt: TDateTime;
  i: Integer;

begin
  if ParamCount = 0 then
  begin
    writeln(now.DiscordianDate);
    readln;
    halt;
  end;

  for i := 1 to ParamCount do
  begin
    if not TryStrToDate(ParamStr(i), dt) then
      Continue;
    writeln(dt.DiscordianDate);
  end;

  readln;
end.
