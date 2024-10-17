program Permutation_test;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

procedure Comb(n, m: Integer; emit: TProc<TArray<Integer>>);
var
  s: TArray<Integer>;
  last: Integer;

  procedure rc(i, next: Integer);
  begin
    for var j := next to n - 1 do
    begin
      s[i] := j;
      if i = last then
        emit(s)
      else
        rc(i + 1, j + 1);
    end;
  end;

begin
  SetLength(s, m);
  last := m - 1;
  rc(0, 0);
end;

begin
  var tr: TArray<Integer> := [85, 88, 75, 66, 25, 29, 83, 39, 97];
  var ct: TArray<Integer> := [68, 41, 10, 49, 16, 65, 32, 92, 28, 98];

  // collect all results in a single list
  var all: TArray<Integer> := concat(tr, ct);

  // compute sum of all data, useful as intermediate result
  var sumAll := 0;
  for var r in all do
    inc(sumAll, r);

  // closure for computing scaled difference.
  // compute results scaled by len(tr)*len(ct).
  // this allows all math to be done in integers.
  var sd :=
    function(trc: TArray<Integer>): Integer
    begin
      var sumTr := 0;
      for var x in trc do
        inc(sumTr, all[x]);
      result := sumTr * length(ct) - (sumAll - sumTr) * length(tr);
    end;

  // compute observed difference, as an intermediate result
  var a: TArray<Integer>;
  SetLength(a, length(tr));
  for var i := 0 to High(a) do
    a[i] := i;

  var sdObs := sd(a);

  // iterate over all combinations.  for each, compute (scaled)
  // difference and tally whether leq or gt observed difference.
  var nLe, nGt: Integer;

  comb(length(all), length(tr),
    procedure(c: TArray<Integer>)
    begin
      if sd(c) > sdObs then
        inc(nGt)
      else
        inc(nle);
    end);

  // print results as percentage
  var pc := 100 / (nLe + nGt);
  writeln(format('differences <= observed: %f%%', [nle * pc]));
  writeln(format('differences  > observed: %f%%', [ngt * pc]));

  {$IFNDEF UNIX} readln; {$ENDIF}
end.
