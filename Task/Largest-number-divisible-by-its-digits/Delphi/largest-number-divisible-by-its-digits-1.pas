program Largest_number_divisible_by_its_digits;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TSetAnsiChar = set of AnsiChar;

function DivByAll(num: Integer; digits: TSetAnsiChar): Boolean;
var
  offset: byte;
begin
  offset := ord('0');
  for var d in digits do
  begin
    if (num mod (ord(d) - offset)) <> 0 then
      exit(false);
  end;
  Result := true;
end;

begin
  var magic: Cardinal := 9 * 8 * 7;
  var h: Cardinal := 9876432 div magic * magic;
  for var i := h downto magic do
  begin
    if i mod 10 = 0 then
      Continue;

    var s := i.tostring;
    if (s.indexOf('0') > -1) or (s.indexOf('5') > -1) then
      Continue;
    var digits: TSetAnsiChar := [];
    var isUnic := true;
    for var b in ansistring(s) do
      if not (b in digits) then
        Include(digits, b)
      else
      begin
        isUnic := false;
        break;
      end;

    if not isUnic then
      Continue;

    if DivByAll(i, digits) then
    begin
      writeln('Largest decimal number is ', i);
      Break;
    end;
  end;
  readln;
end.
