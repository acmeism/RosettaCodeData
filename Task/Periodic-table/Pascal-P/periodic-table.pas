program periodtabl(output);

var
  a, b: array [0 .. 7] of integer;

  procedure showrowandcolumn(anum: integer);
  var
    i, m, r, c: integer;
  begin
    i := 7;
    while a[i] > anum do
      i := i - 1;
    m := anum + b[i];
    r := m div 18 + 1;
    c := m mod 18 + 1;
    write(anum: 3, ' ->', r: 2, c: 3);
    writeln;
  end;

  procedure initab;
  begin
    a[0] := 1;
    a[1] := 2;
    a[2] := 5;
    a[3] := 13;
    a[4] := 57;
    a[5] := 72;
    a[6] := 89;
    a[7] := 104;
    b[0] := -1;
    b[1] := 15;
    b[2] := 25;
    b[3] := 35;
    b[4] := 72;
    b[5] := 21;
    b[6] := 58;
    b[7] := 7;
  end;

begin
  initab;
  (* Test for example elements (atomic numbers) *)
  showrowandcolumn(  1);
  showrowandcolumn(  2);
  showrowandcolumn( 29);
  showrowandcolumn( 42);
  showrowandcolumn( 57);
  showrowandcolumn( 58);
  showrowandcolumn( 72);
  showrowandcolumn( 89);
  showrowandcolumn( 90);
  showrowandcolumn(103);
end.
