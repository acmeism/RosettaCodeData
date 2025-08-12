begin
  var lines := new string[]
  (
    '---------- Ice and Fire ------------',
    '',
    'fire, in end will world the say Some',
    'ice. in say Some',
    'desire of tasted I''ve what From',
    'fire. favor who those with hold I',
    '',
    '... elided paragraph last ...',
    '',
    'Frost Robert -----------------------'
  );

  foreach var line in lines do
  begin
    // Разбиваем строку на слова (по пробелам), фильтруем пустые
    var words := line.Split(' ').Where(w -> w <> '').ToArray();

    // Меняем порядок слов на обратный
    words := words.Reverse().ToArray();

    // Собираем обратно в строку через пробел
    var reversedLine := String.Join(' ', words);

    Writeln(reversedLine);
  end;
end.
