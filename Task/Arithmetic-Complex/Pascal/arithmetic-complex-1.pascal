program showcomplex(output);

type
 complex = record
            re,im: real
           end;

var
 z1, z2, zr: complex;

procedure set(var result: complex; re, im: real);
 begin
  result.re := re;
  result.im := im
 end;

procedure print(a: complex);
 begin
  write('(', a.re , ',', a.im, ')')
 end;

procedure add(var result: complex; a, b: complex);
 begin
  result.re := a.re + b.re;
  result.im := a.im + b.im;
 end;

procedure neg(var result: complex; a: complex);
 begin
  result.re := -a.re;
  result.im := -a.im
 end;

procedure mult(var result: complex; a, b: complex);
 begin
  result.re := a.re*b.re - a.im*b.im;
  result.im := a.re*b.im + a.im*b.re
 end;

procedure inv(var result: complex; a: complex);
 var
  anorm: real;
 begin
  anorm := a.re*a.re + a.im*a.im;
  result.re := a.re/anorm;
  result.im := -a.im/anorm
 end;

begin
 set(z1, 3, 4);
 set(z2, 5, 6);

 neg(zr, z1);
 print(zr); { prints (-3,-4) }
 writeln;

 add(zr, z1, z2);
 print(zr); { prints (8,10) }
 writeln;

 inv(zr, z1);
 print(zr); { prints (0.12,-0.16) }
 writeln;

 mul(zr, z1, z2);
 print(zr); { prints (-9,38) }
 writeln
end.
