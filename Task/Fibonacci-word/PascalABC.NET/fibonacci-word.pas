function entropy(str: string): real;
begin
  //  ## return the entropy of a fibword string.
  if str.length <= 1 then begin result := 0.0; exit end;
  var strlen := str.length;
  var count0 := str.where(c -> c = '0').count;
  var count1 := strlen - count0;
  result := -(count0 / strlen * log2(count0 / strlen) + count1 / strlen * log2(count1 / strlen))
end;

function fibword(): sequence of string;
begin
  //  ## Yield the successive fibwords.
  var a := '1'.ToString;
  var b := '0'.ToString;
  yield a;
  yield b;
  while true do
  begin
    a := b + a;
    swap(a, b);
    yield b
  end;
end;

begin
  println(' n    length       entropy');
  println('————————————————————————————————');
  var n := 0;
  foreach var str in fibword do
  begin
    n += 1;
    write(n:2, str.length:10, entropy(str):18:14);
    if n < 10 then writeln('  ', str) else writeln;
    if n = 37 then break
  end;
end.
