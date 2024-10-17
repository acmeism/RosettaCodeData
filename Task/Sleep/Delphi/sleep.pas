program SleepOneSecond;

{$APPTYPE CONSOLE}

uses SysUtils;

var
  lTimeToSleep: Integer;
begin
  if ParamCount = 0 then
    lTimeToSleep := 1000
  else
    lTimeToSleep := StrToInt(ParamStr(1));
  WriteLn('Sleeping...');
  Sleep(lTimeToSleep); // milliseconds
  WriteLn('Awake!');
end.
