const
  alphabet = '01';

function next_word(n: integer; w: string): string;
begin
  var x := (w * ((n div w.length) + 1))[:n+1];
  while (x <> '') and (x.Last = alphabet.last) do
    x := x[:x.count];
  if x <> '' then
  begin
    var last_char := x.last;
    var next_char_index := alphabet.indexof(last_char) + 1;
    x := x[:x.Count] + alphabet[next_char_index + 1];
  end;
  result := x;
end;

function generate_lyndon_words(n: integer): sequence of string;
begin
  var w:string := alphabet[1];
  while w.count <= n do
  begin
    yield w;
    w := next_word(n, w);
    if w = '' then break;
  end;
end;

begin
  var lyndon_words := generate_lyndon_words(5);
  foreach var word in lyndon_words do
    print(word)
end.
