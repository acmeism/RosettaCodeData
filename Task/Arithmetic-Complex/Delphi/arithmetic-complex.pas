program Arithmetic_Complex;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.VarCmplx;

var
  a, b: Variant;

begin
  a := VarComplexCreate(5, 3);
  b := VarComplexCreate(0.5, 6.0);

  writeln(format('(%s) + (%s) = %s',[a,b, a+b]));

  writeln(format('(%s) * (%s) = %s',[a,b, a*b]));

  writeln(format('-(%s) = %s',[a,- a]));

  writeln(format('1/(%s) = %s',[a,1/a]));

  writeln(format('conj(%s) = %s',[a,VarComplexConjugate(a)]));

  Readln;
end.
