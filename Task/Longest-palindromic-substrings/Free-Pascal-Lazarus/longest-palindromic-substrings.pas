program FindLongestPalindrome;

uses
  SysUtils,strutils;

const
  arr: array of string = ('three old rotators', 'never reverse', 'stable was I ere I saw elbatrosses', 'abracadabra', 'drome', 'the abbatial palace', '');

var
  st, longestPalindrome, dummy: string;
  i, j, longest: integer;

begin
  for st in arr do
  begin
    longest := 0;
    longestPalindrome := '';
    for i := 1 to Length(st) do
    begin
      for j := Length(st) downto i do
      begin
        dummy := Copy(st, i, j - i + 1);
        if (j - i + 1 > longest) and (dummy = ReverseString(dummy)) then
        begin
          longest := j - i + 1;
          longestPalindrome := dummy;
        end;
      end;
    end;
    WriteLn(Format('%-35s -> %s', [st, longestPalindrome]));
  end;
end.

