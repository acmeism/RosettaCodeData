function shuffle(deck: list<integer>) := deck[:deck.Count div 2].Interleave(deck[deck.Count div 2:]);

function number(size: integer): integer;
begin
  assert(size mod 2 = 0, 'size must be even');
  var start := Range(1, size).ToList;
  var deck := Range(1, size).ToList;
  var counter := 0;
  repeat
    deck := shuffle(deck).ToList;
    counter += 1;
  until deck.SequenceEqual(start);
  result := counter;
end;

begin
  foreach var size in |8, 24, 52, 100, 1020, 1024, 10_000| do
    writeln(size:5, ': ', number(size):4);
end.
