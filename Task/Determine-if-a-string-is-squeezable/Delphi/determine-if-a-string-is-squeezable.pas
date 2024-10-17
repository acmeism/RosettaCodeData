program Determine_if_a_string_is_squeezable;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

var
  TestStrings: TArray<string> = ['',
    '''If I were two-faced, would I be wearing this one?'' --- Abraham Lincoln ',
    '..1111111111111111111111111111111111111111111111111111111111111117777888',
    'I never give ''em hell, I just tell the truth, and they think it''s hell. ',
    '                                                    --- Harry S Truman  ',
    '122333444455555666666777777788888888999999999',
    'The better the 4-wheel drive, the further you''ll be from help when ya get stuck!',
    'headmistressship'];
  TestChar: TArray<string> = [' ', '-', '7', '.', ' -r', '5', 'e', 's'];

function squeeze(s: string; include: char): string;
begin
  var sb := TStringBuilder.Create;
  for var i := 1 to s.Length do
  begin
    if (i = 1) or (s[i - 1] <> s[i]) or ((s[i - 1] = s[i]) and (s[i] <> include)) then
      sb.Append(s[i]
  end;
  Result := sb.ToString;
  sb.Free;
end;

begin
  for var testNum := 0 to high(TestStrings) do
  begin
    var s := TestStrings[testNum];
    for var c in TestChar[testNum] do
    begin
      var result: string := squeeze(s, c);
      writeln(format('use: "%s"'#10'old:  %2d <<<%s>>>'#10'new:  %2d <<<%s>>>'#10, [c,
        s.Length, s, result.length, result]));
    end;
  end;
  readln;
end.
