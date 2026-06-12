function GetOdd(const w: string): string;
begin
  Result := '';
  for var i := 1 to w.Length do
    if i mod 2 = 1 then // нечётные
      Result += w[i];
end;

begin
  var words := ReadAllLines('unixdict.txt');

  // HashSet Для быстрого поиска
  var wordSet := new HashSet<string>(words);

  foreach var word in words do
  begin
    var ow := GetOdd(word);
    if (ow.Length > 4) and wordSet.Contains(ow) then
      Writeln(word, ' => ', ow);
  end;
end.
