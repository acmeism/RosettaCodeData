function magicnumbers(): sequence of biginteger;
begin
  var prevlist := (1..9).Select(x -> biginteger(x)).ToList;
  var newlist := new List<biginteger>;
  var digits := 2;

  yield 0bi;
  while prevlist.Count > 0 do
  begin
    yield sequence prevlist;
    foreach var n in prevlist do
      foreach var j in 0..9 do
      begin
        var number := 10bi * n + j;
        if number mod digits = 0 then
          newlist.Add(number)
      end;

    prevlist := newlist;
    newlist := new list<biginteger>;
    digits += 1;
  end;
end;

begin
  println('There are', magicnumbers.Count, 'magic numbers.');
  Println('The largest magic number is:', magicnumbers.Last);
  println;

  println('Magic number count by digits:');
  var groups := magicnumbers
                .GroupBy(n -> n.tostring.count)
                .Select(g -> (g.key, g.count));
  foreach var group in groups do
    writeln(group[0]:2, group[1]:8);
  println;

  print('Magic numbers that are minimally pandigital in 1-9:');
  magicnumbers.Where(n -> n.ToString.Count = 9)
              .Where(n -> (n.ToString.ToSet.Count = 9)
                          and (not n.ToString.Contains('0')))
              .Println;

  print('Magic numbers that are minimally pandigital in 0-9:');
  magicnumbers.Where(n -> n.ToString.Count = 10)
              .Where(n -> n.Tostring.ToSet.Count = 10)
              .Println;
end.
