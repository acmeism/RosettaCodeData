program SplitChars;
{$IFDEF FPC}
  {$MODE DELPHI}{$COPERATORS ON}
{$ENDIF}
const
  TestString =  'gHHH5YY++///\';

function SplitAtChars(const S: String):String;
var
  i : integer;
  lastChar:Char;
begin
  result := '';
  IF length(s) > 0 then
  begin
    LastChar := s[1];
    result := LastChar;
    For i := 2 to length(s) do
    begin
      if s[i] <> lastChar then
      begin
        lastChar := s[i];
        result += ', ';
      end;
      result += LastChar;
    end;
  end;
end;

BEGIN
  writeln(SplitAtChars(TestString));
end.
