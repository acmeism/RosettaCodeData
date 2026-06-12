uses System;

function SattoloShuffle(ar: array of integer): array of integer;
var
  n := Length(ar);
  res: array of integer;
  rnd := new Random();
begin
  if n <= 1 then
  begin
    Result := ar;
    exit;
  end;

  res := Copy(ar); // копируем массив

  for var i := n - 1 downto 1 do
  begin
    var j := rnd.Next(i); // j < i
    Swap(res[i], res[j]);
  end;

  Result := res;
end;

var
  m, shuffled: array of integer;

begin
  var Cases:= [[],     [10],     [10, 20],     [10, 20, 30],
               [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]];
   foreach var x in Cases do begin
  Write('Исходный массив: ');
  Println(x);

  shuffled := SattoloShuffle(x);
  Write('Перемешанный массив: ');
  Println(shuffled);

  // Проверка, что ни один элемент не на месте
  var isDerangement := true;
  if x.Length<2 then Writeln('нужно минимум два элемента')
    else begin
  for var i := 0 to Length(x) - 1 do
    if x[i] = shuffled[i] then
      isDerangement := false;

  if isDerangement then
    Writeln('Проверка: элементы на разных местах.')
  else
    Writeln('есть не перемещённые элементы - это ошибка.');
    end;
  Writeln;end;
end.
