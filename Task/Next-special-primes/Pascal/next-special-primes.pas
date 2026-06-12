program NextSpecialprimes;
//increasing prime gaps see
//https://oeis.org/A002386  https://en.wikipedia.org/wiki/Prime_gap
uses
  sysutils,
  primTrial;

procedure GetIncreasingGaps;
var
  Gap,LastPrime,p : NativeUInt;
Begin
  InitPrime;
  Writeln('next increasing prime gap');
  writeln('Prime1':8,'Prime2':8,'Gap':4);
  Gap := 0;
  LastPrime := actPrime;
  repeat
    p := NextPrime;
    if p-LastPrime > Gap then
    Begin
      Gap := p-LastPrime;
      writeln(LastPrime:8,P:8,Gap:4);

    end;
    LastPrime := p;
  until LastPrime > 1000;
end;

procedure NextSpecial;
var
  Gap,LastPrime,p : NativeUInt;
Begin
  InitPrime;
  Writeln('next special prime');
  writeln('Prime1':8,'Prime2':8,'Gap':4);
  Gap := 0;
  LastPrime := actPrime;
  repeat
    p := NextPrime;
    if p-LastPrime > Gap then
    Begin
      Gap := p-LastPrime;
      writeln(LastPrime:8,P:8,Gap:4);
      LastPrime := p;
    end;

  until LastPrime > 1000;
end;

begin
  GetIncreasingGaps;
  writeln;
  NextSpecial;
end.
