function Rim2Arab(S : String) : Integer;
const //римские числа на соответствующие десятичные числа
R : array[1..14] of String[2] = ('M','CM','D','CD','C','XC','L','XL','X','IX','V','IV','I',' ');
A : array[1..14] of Integer = (1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1, 0);
begin
  var i := 1;
  Result := 0;
  while S.Length > 0 do
    begin
      while S.IndexOf(R[i]) = 0 do
        begin
          S := S.Remove(0, R[i].Length);
          Result += A[i]
        end;
      i += 1;
    end;
end;

const
   L = 'IVXLCDM';
begin
  var S := 'MDCLXVI';//'roman numeral:';
  Write(S,': ');
  var index := 1;
  repeat
    if L.IndexOf(S[index]) < 0 then
      index += 1
    else
      begin
        var Rim : String := '';
        repeat
          Rim += S[index];
          S := S.Remove(index - 1, 1);
        until (S.Length < index) or (L.IndexOf(S[index]) < 0);
        S := S.Insert(index - 1, Rim2Arab(Rim).ToString);
      end;
  until index > S.Length;
  WriteLn(S);
end.
