begin
  var words := new HashSet<string>();
  var lines := ReadAllLines('unixdict.txt');

  // Загружаем слова в HashSet для быстрого поиска
  foreach var line in lines do
    words.Add(line.Trim);

  foreach var word in words do
  begin
    if word.Length < 6 then
      continue;

    if not word.Contains('e') then
      continue;

    var iw := word.Replace('e', 'i');

    if words.Contains(iw) then
      Writeln(word, ' => ', iw);
  end;
end.
