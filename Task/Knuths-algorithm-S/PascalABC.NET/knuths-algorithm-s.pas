function s_of_n_creator<T>(n: integer): T-> list<T>;
begin
  var sample := new List<T>;
  var i := 0;

  result := function(item: T): list<T> ->
            begin
              i += 1;
              if i <= n then
                sample.add(item)
              else if random(i) < n then
                sample[random(n)] := item;
              result := sample;
            end;
end;

begin
  println('Digits counts for 100_000 runs:');
  var hist: array [0..9] of integer;
  var sample := new List<integer>;
  loop 100_000 do
  begin
    var s_of_n := s_of_n_creator&<integer>(3);
    for var i := 0 to 9 do
      sample := s_of_n(i);
    foreach var val in sample do
      hist[val] += 1;
  end;

  foreach var count in hist index n do
    writeln(n, ': ', count);
end.
