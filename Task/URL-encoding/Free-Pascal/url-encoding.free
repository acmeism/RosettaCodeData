function urlEncode(data: string): AnsiString;
var
  ch: AnsiChar;
begin
  Result := '';
  for ch in data do begin
    if ((Ord(ch) < 65) or (Ord(ch) > 90)) and ((Ord(ch) < 97) or (Ord(ch) > 122)) then begin
      Result := Result + '%' + IntToHex(Ord(ch), 2);
    end else
      Result := Result + ch;
  end;
end;
