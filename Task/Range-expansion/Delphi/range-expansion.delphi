program Range_expansion;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

const
  input = '-6,-3--1,3-5,7-11,14,15,17-20';

var
  r: TArray<Integer>;
  last, i, n: Integer;

begin
  for var part in input.Split([',']) do
  begin
    i := part.Substring(1).IndexOf('-');
    if i = -1 then
    begin
      if not TryStrToInt(part, n) then
        raise Exception.Create('Error: value invalid ' + part);
      if Length(r) > 0 then
        if last = n then
        begin
          raise Exception.Create('Error: Duplicate value:' + n.ToString);
        end
        else
        begin
          if last > n then
            raise Exception.CreateFmt('Error: values not ordered: %s > %s', [last, n]);
        end;
      SetLength(r, Length(r) + 1);
      r[High(r)] := n;
      last := n;
    end
    else
    begin
      var n1 := 0;
      var n2 := 0;
      if not TryStrToInt(part.Substring(0, i + 1), n1) then
        raise Exception.Create('Error: value invalid ' + part);
      if not TryStrToInt(part.Substring(i + 2), n2) then
        raise Exception.Create('Error: value invalid ' + part);
      if n2 < n1 + 2 then
        raise Exception.Create('Error: Invalid range' + part);
      if Length(r) > 0 then
      begin
        if last = n1 then
          raise Exception.Create('Error: Duplicate value: ' + n1.ToString);
        if last > n1 then
          raise Exception.CreateFmt('Error: Values not ordened: %d > %d', [last, n1]);
      end;

      for i := n1 to n2 do
      begin
        SetLength(r, Length(r) + 1);
        r[High(r)] := i;
      end;

      last := n2;
    end;
  end;
  write('expanded: ');
  for var rr in r do
  begin
    write(rr, ',');
  end;
  readln;
end.
