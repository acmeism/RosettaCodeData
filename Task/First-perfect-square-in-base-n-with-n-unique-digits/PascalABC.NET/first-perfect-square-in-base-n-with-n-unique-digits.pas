uses School;

const
  valid_chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

function ToBase(number: int64; base: integer): string;
begin
  var sb := new System.Text.StringBuilder('');
  while number > 0 do
  begin
    sb.Insert(0, valid_chars[integer(number mod base) + 1]);
    number := number div base
  end;
  Result := if sb.Length = 0 then '0'
    else sb.ToString
end;

begin
  var n: Int64 := 1;
  for var base := 2 to 15 do
  begin
    while True do
    begin
      var nn: int64 := n * n;
      var dd := ToBase(nn,base);
      if (dd.Length >= base) and (dd.ToHashSet.Count = base) then
      begin
        Println($'{base,2} {ToBase(n,base),8}^2 = {ToBase(n*n,base)}');
        break;
      end;
      n += 1;
    end;
  end;
end.
