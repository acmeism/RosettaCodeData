function pal_gen(): sequence of BigInteger;
begin
  var o := 10;
  var e := 10;
  repeat
    var fwd_o := o.ToString;
    var fwd_e := e.ToString;
    var rev_o := fwd_o[^2:0:-1];
    var rev_e := fwd_e[::-1];
    var pal := Min((fwd_o + rev_o).ToBigInteger, (fwd_e + rev_e).ToBigInteger);
    yield pal;
    if pal.ToString.Length.IsEven then e += 1 else o += 1;
  until false;
end;

function is_gapful(n: BigInteger) := n mod (n.ToString[1].ToDigit * 10 + (n mod 10)) = 0;

begin
  writeln('palindromic gapful numbers from 1 to 20:');
  for var i := 1 to 9 do
    writeln(i, ': ', pal_gen.Where(n -> is_gapful(n)).Where(n -> n mod 10 = i).Take(20));
  writeln;
  writeln('palindromic gapful numbers from 86 to 100:');
  for var i := 1 to 9 do
    writeln(i, ': ', pal_gen.Where(n -> is_gapful(n)).Where(n -> n mod 10 = i).Skip(85).Take(15));
  writeln;
  writeln('palindromic gapful numbers from 991 to 1000:');
  for var i := 1 to 9 do
    writeln(i, ': ', pal_gen.Where(n -> is_gapful(n)).Where(n -> n mod 10 = i).Skip(990).Take(10));
end.
