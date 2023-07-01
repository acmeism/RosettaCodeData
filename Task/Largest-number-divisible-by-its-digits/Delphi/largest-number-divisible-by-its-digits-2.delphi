program Largest_number_divisible_by_its_digits;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TSetAnsiChar = set of AnsiChar;

function DivByAll(num: Uint64; digits: TSetAnsiChar): Boolean;
var
  offset_dec, offset_hex: byte;
begin
  offset_dec := ord('0');
  offset_hex := ord('W');

  for var digit in digits do
  begin
    var d: byte := 0;
    if digit <= '9' then
      d := ord(digit) - offset_dec
    else
      d := ord(digit) - offset_hex;
    if (num mod d) <> 0 then
      exit(false);
  end;
  Result := true;
end;

begin
  var magic: Uint64 := 15 * 14 * 13 * 12 * 11;
  var h: Uint64 := $fedcba987654321 div magic * magic;
  writeln('Wait while search for');
  for var i := h downto magic do
  begin
    if (i mod 16) = 0 then
      Continue;

    var s := i.ToHexString(0).ToLower;
    if (s.indexOf('0') > -1) then
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
      writeln('Largest hex number is ', i.ToHexString);
      Break;
    end;
  end;
  readln;
end.
