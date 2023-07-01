program Factorions;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

begin
  var fact: TArray<UInt64>;
  SetLength(fact, 12);

  fact[0] := 0;
  for var n := 1 to 11 do
    fact[n] := fact[n - 1] * n;

  for var b := 9 to 12 do
  begin
    writeln('The factorions for base ', b, ' are:');
    for var i := 1 to 1499999 do
    begin
      var sum := 0;
      var j := i;
      while j > 0 do
      begin
        var d := j mod b;
        sum := sum + fact[d];
        j := j div b;
      end;
      if sum = i then
        writeln(i, ' ');
    end;
    writeln(#10);
  end;
  readln;
end.
