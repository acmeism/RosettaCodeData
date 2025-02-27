function digits(n: biginteger): list<byte>;
begin
  // Return the list of digits of "n" in reverse order.
  result := new list<byte>;
  if n = 0 then result.add(0);
  while n <> 0 do
  begin
    result.add(byte(n mod 10));
    n := n div 10;
  end;
end;

function nextHighest(n: biginteger): biginteger;
begin
  // Find the next highest integer of "n".
  // If none is found, "n" is returned.
  var d := digits(n); // Warning: in reverse order.
  var m := d[0];
  foreach var i in 1..d.Count - 1 do
    if d[i] < m then
    begin
      // Find the digit greater then d[i] and closest to it.
      var delta := m - d[i] + 1;
      var best: integer;
      foreach var j in 0..i - 1 do
      begin
        var diff := d[j] - d[i];
        if (diff > 0) and (diff < delta) then
        begin
          // Greater and closest.
          delta := diff;
          best := j;
        end;
      end;
      // Exchange digits.
      (d[i], d[best]) := (d[best], d[i]);
      // Sort previous digits.
      var (d1, d2) := d.SplitAt(i);
      d := d1.SortedDescending.ToList + d2.ToList;
      break;
    end
    else m := d[i];
  // Compute the value from the digits.
  foreach var val in d[::-1] do
    result := 10 * result + val;
end;

begin
  foreach var n in [0, 9, 12, 21, 12453, 738440, 45072010, 95322020] do
    println(n, ' → ', nextHighest(n));
  var n := '9589776899767587796600'.ToBigInteger;
  println(n, '→', nextHighest(n));
end.
