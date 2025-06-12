function pancake(n: integer): (integer, string);
begin
  var goalstack := '123456789abcd'[:n + 1];
  var stacks := Dict((goalstack, 0));
  var newstacks := Dict((goalstack, 0));
  var numstacks := 1;
  foreach var flip in 1..100 do
  begin
    var nextstacks := new Dictionary<string, integer>;
    foreach var nstack in newstacks do
      foreach var pos in 2..n do
      begin
        var newstack := nstack.key[pos::-1] + nstack.key?[pos + 1:];
        if newstack not in stacks then
          nextstacks[newstack] := flip;
      end;
    newstacks := nextstacks;
    foreach var nstack in newstacks do stacks[nstack.key] := nstack.value;
    var perms := stacks.Count;
    if perms = numstacks then
    begin
      result := stacks.Where(x -> x.value = flip - 1)
                      .Select(k -> (k.value, k.key))
                      .First;
      exit
    end;
    numstacks := perms
  end;
end;

begin
  foreach var n in 1..11 do
  begin
    var (steps, example) := pancake(n);
    writeln('pancake(', n:2, ') = ', steps:2, '  example: ', example);
  end;
end.
