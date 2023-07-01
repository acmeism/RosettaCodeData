{ RossetaCode: Sum to 100, Pascal.

  Find solutions to the "sum to one hundred" puzzle.

  We don't use arrays, but recompute all values again and again.
  It is a little surprise that the time efficiency is quite acceptable. }

program sumto100;

const
  ADD = 0; SUB = 1; JOIN = 2; { opcodes inserted between digits }
  NEXPR = 13122;              { the total number of expressions }
var
  i, j: integer;
  loop: boolean;
  test, ntest, best, nbest, limit: integer;

  function evaluate(code: integer): integer;
  var
    k: integer;
    value, number, power: integer;
  begin
    value  := 0;
    number := 0;
    power  := 1;
    for  k := 9 downto 1 do
    begin
      number := power * k + number;
      case code mod 3 of
        ADD: begin value := value + number; number := 0; power := 1; end;
        SUB: begin value := value - number; number := 0; power := 1; end;
        JOIN:                                            power := power * 10
      end;
      code := code div 3
    end;
    evaluate := value
  end;

  procedure print(code: integer);
  var
    k: integer;
    a, b: integer;
  begin
    a := 19683;
    b := 6561;
    write( evaluate(code):9 );
    write(' = ');
    for  k := 1 to 9 do
    begin
      case ((code mod a) div b) of
        ADD: if k > 1 then write('+');
        SUB: { always }    write('-');
      end;
      a := b;
      b := b div 3;
      write( k:1 )
    end;
    writeln
  end;

begin
  writeln;
  writeln('Show all solutions that sum to 100');
  writeln;
  for i := 0 to NEXPR - 1 do
    if evaluate(i) = 100 then
      print(i);

  writeln;
  writeln('Show the sum that has the maximum number of solutions');
  writeln;
  nbest := (-1);
  for i := 0 to NEXPR - 1 do
  begin
    test := evaluate(i);
    if test > 0 then
    begin
      ntest := 0;
      for j := 0 to NEXPR - 1 do
        if evaluate(j) = test then
          ntest := ntest + 1;
      if ntest > nbest then
      begin
        best := test;
        nbest := ntest;
      end
    end
  end;
  writeln(best, ' has ', nbest, ' solutions');

  writeln;
  writeln('Show the lowest positive number that can''t be expressed');
  writeln;
  i := 0;
  loop := TRUE;
  while (i <= 123456789) and loop do
  begin
    j := 0;
    while (j < NEXPR - 1) and (i <> evaluate(j)) do
      j := j + 1;
    if i <> evaluate(j) then
      loop := FALSE
    else
      i := i + 1;
  end;
  writeln(i);

  writeln;
  writeln('Show the ten highest numbers that can be expressed');
  writeln;
  limit := 123456789 + 1;
  for i := 1 to 10 do
  begin
    best := 0;
    for j := 0 to NEXPR - 1 do
    begin
      test := evaluate(j);
      if (test < limit) and (test > best) then
        best := test;
    end;
    for j := 0 to NEXPR - 1 do
      if evaluate(j) = best then
        print(j);
    limit := best;
  end
end.
