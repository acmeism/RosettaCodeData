Program ComplexDemo;

uses
  ucomplex;

var
  a, b, absum, abprod, aneg, ainv, acong: complex;

function complex(const re, im: real): ucomplex.complex; overload;
  begin
    complex.re := re;
    complex.im := im;
  end;

begin
  a      := complex(5, 3);
  b      := complex(0.5, 6.0);
  absum  := a + b;
  writeln ('(5 + i3) + (0.5 + i6.0): ', absum.re:3:1, ' + i', absum.im:3:1);
  abprod := a * b;
  writeln ('(5 + i3) * (0.5 + i6.0): ', abprod.re:5:1, ' + i', abprod.im:4:1);
  aneg   := -a;
  writeln ('-(5 + i3): ', aneg.re:3:1, ' + i', aneg.im:3:1);
  ainv   := 1.0 / a;
  writeln ('1/(5 + i3): ', ainv.re:3:1, ' + i', ainv.im:3:1);
  acong  := cong(a);
  writeln ('conj(5 + i3): ', acong.re:3:1, ' + i', acong.im:3:1);
end.
