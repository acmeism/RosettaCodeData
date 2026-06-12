function allcombinations(a: array of integer): sequence of array of integer;
begin
  result := a.Combinations(0);
  for var i := 1 to a.length do result := result + a.combinations(i);
end;

procedure coinsum(coins: array of integer; targetsum: integer; verbose: boolean := true);
begin
  println('Coins are', coins, 'target sum is ', targetsum);
  var combos := 0;
  var perms := 0;
  foreach var choice in allcombinations(coins) do
    if choice.sum = targetsum then
    begin
      combos += 1;
      if verbose then println(choice, 'sums to', targetsum);
      foreach var perm in choice.permutations do
      begin
        if verbose then println('    permutation:', perm);
        perms += 1;
      end
    end;
  println(combos, 'combinations', perms, 'permutations.');
  println;
end;

begin
  coinsum(arr(1, 2, 3, 4, 5), 6, true);
  coinsum(arr(1, 1, 2, 3, 3, 4, 5), 6, false);
  coinsum(arr(1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100), 40, false);
end.
