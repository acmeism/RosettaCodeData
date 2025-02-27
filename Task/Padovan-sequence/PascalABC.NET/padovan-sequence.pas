const
  PP = 1.324717957244746025960908854;
  S = 1.0453567932525329623;

var
  Rules := dict(('A', string('B')), ('B', string('C')), ('C', 'AB'));

function padovan1(n: integer): sequence of integer;
begin
  //  ## Yield the first 'n' Padovan values using recurrence relation.
  loop min(n, 3) do yield 1;
  var (a, b, c) := (1, 1, 1);
  var count := 3;
  while count < n do
  begin
    (a, b, c) := (b, c, a + b);
    yield c;
    count += 1;
  end;
end;

function padovan2(n: integer): sequence of integer;
begin
  //  ## Yield the first 'n' Padovan values using formula.
  if n > 1 then yield 1;
  var p := 1.0;
  var count := 1;
  while count < n do
  begin
    yield (p / S).Round;
    p *= PP;
    count += 1;
  end;
end;

function padovan3(n: integer): sequence of string;
begin
  //  ## Yield the strings produced by the L-system.
  var s: string := 'A';
  var count := 0;
  while count < n do
  begin
    yield s;
    var next := string('');
    foreach var ch in s do
      next += Rules[ch];
    s := next;
    count += 1;
  end;
end;

begin
  println('First 20 terms of the Padovan sequence:');
  println(padovan1(20));

  var list1 := padovan1(64).ToList;
  var list2 := padovan2(64).ToList;
  println('The first 64 iterative and calculated values',
       if list1.SequenceEqual(list2) then 'are the same.' else 'differ.');

  println;
  println('First 10 L-system strings:');
  println(padovan3(10));
  println;
  println('Lengths of the 32 first L-system strings:');
  var list3 := padovan3(32).select(it -> it.Length).ToList;
  list3.println;
  writeln('These lengths are ',
  if list3.SequenceEqual(list1[0:32]) then '' else 'not ',
  'the 32 first terms of the Padovan sequence.');
end.
