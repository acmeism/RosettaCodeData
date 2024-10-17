function popcount(n: int64) := Convert.ToString(n, 2).Count(x -> x = '1');

begin
  Print('pow3:   ');
  (0..29).Select(x -> popcount(int64(3 ** x))).Println;
  Print('evil:   ');
  (0..99).Where(x -> popcount(x).Iseven).Take(30).Println;
  Print('odious: ');
  (0..99).Where(x -> popcount(x).Isodd).Take(30).Println;
end.
