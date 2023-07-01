program Pascal_matrix(Output);

const N = 5;

type NxN_Matrix = array[0..N,0..N] of integer;

var PM,PX : NxN_Matrix;

function Pascal_sym(x : integer; p : NxN_Matrix) : NxN_Matrix;
var I,J : integer;
  begin
    for I := 1 to x do
    begin
      for J := 1 to x do p[I,J] := p[I-1,J]+p[I,J-1]
    end;
    Pascal_sym := p;
  end;

function Pascal_upp(x : integer; p : NxN_Matrix) : NxN_Matrix;
var I,J : integer;
  begin
    for I := 1 to x do
    begin
      for J := 1 to x do p[I,J] := p[I-1,J-1]+p[I,J-1]
    end;
    Pascal_upp := p
  end;

function Pascal_low(x : integer; p : NxN_Matrix) : NxN_Matrix;
var p1,p2 : NxN_Matrix;
  I,J : integer;
  begin
    p1 := Pascal_upp(x,p);
    p2 := p1;
    for I := 1 to x do
    begin
      for J := 1 to x do p1[J,I] := p2[I,J]
    end;
    Pascal_low := p1
  end;

procedure PrintMatrix(titel : ansistring; x : integer; p : NxN_Matrix);
var I,J : integer;
  begin
    writeln(titel);
    for I := 1 to x do
    begin
      for J := 1 to x do write(p[I,J]:5);
      writeln('');
    end;
  end;

begin
  PX[0,0] := 0;
  PM[0,0] := 1;
  PM := Pascal_upp(N, PM);
  PrintMatrix('Upper:', N, PM);
  writeln('');
  PM := PX;
  PM[0,0] := 1;
  PM := Pascal_low(N, PM);
  PrintMatrix('Lower:', N, PM);
  writeln('');
  PM := PX;
  PM[1,0] := 1;
  PM := Pascal_sym(N, PM);
  PrintMatrix('Symmetric', N, PM);
  writeln('');
  readln;
end.
