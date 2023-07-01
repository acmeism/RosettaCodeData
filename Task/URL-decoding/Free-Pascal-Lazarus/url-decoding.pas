function urlDecode(data: String): AnsiString;
var
  ch: Char;
  pos, skip: Integer;

begin
  pos := 0;
  skip := 0;
  Result := '';

  for ch in data do begin
    if skip = 0 then begin
      if (ch = '%') and (pos < data.length -2) then begin
        skip := 2;
        Result := Result + AnsiChar(Hex2Dec('$' + data[pos+2] + data[pos+3]));

      end else begin
        Result := Result + ch;
      end;

    end else begin
      skip := skip - 1;
    end;
    pos := pos +1;
  end;
end;
