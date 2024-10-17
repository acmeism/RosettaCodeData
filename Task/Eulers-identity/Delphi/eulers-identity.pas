program Euler_identity;

{$APPTYPE CONSOLE}

uses
  System.VarCmplx;

begin
  var result := VarComplexExp(Pi * VarComplexCreate(0, 1)) + 1;
  writeln(result);
  readln;
end.
