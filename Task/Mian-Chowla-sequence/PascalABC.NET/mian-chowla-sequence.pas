function mian_chowla(): sequence of integer;
label 1;
begin
  var mc := Lst(1);
  yield 1;
  var psums: set of integer := [2];
  var newsums: set of integer := [];
  foreach var trial in 2.Step do
  begin
    foreach var n in (mc + [trial]) do
    begin
      var sum := n + trial;
      if sum in psums then goto 1;
      newsums.add(sum)
    end;
    psums += newsums;
    mc.add(trial);
    yield trial;
    1: newsums := [];
  end;
end;

begin
  println('The first 30 terms of the Mian-Chowla sequence are:');
  mian_chowla.Take(30).Println;
  println;
  println('Terms 91 to 100 of the Mian-Chowla sequence are:');
  mian_chowla.Skip(90).Take(10).Println;
end.
