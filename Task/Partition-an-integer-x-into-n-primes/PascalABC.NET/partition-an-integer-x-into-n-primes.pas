uses School;

function primepartition(x, n: Integer): List<integer>;
begin
  result := new List<integer>;
  foreach var combo in Primes(x).Combinations(n) do
    if combo.Sum = x then
    begin
      result := combo.ToList;
      exit
    end;
end;

begin
  foreach var (x, n) in |(18, 2), (19, 3), (20,  4), (99807, 1), (99809, 1),
  (2017, 24), (22699, 1), (22699, 2), (22699,  3), (22699, 4), (40355, 3)| do
  begin
    var ans := primepartition(x, n);
    writeln('Partitioned', x:6, ' with', n:3, ' primes: ',
        if ans.Count = 0 then 'impossible' else ans.JoinToString('+'));
  end
end.
