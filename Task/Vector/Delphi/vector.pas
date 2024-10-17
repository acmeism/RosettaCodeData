program Vector;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Math.Vectors,
  SysUtils;

procedure VectorToString(v: TVector);
begin
  WriteLn(Format('(%.1f + i%.1f)', [v.X, v.Y]));
end;

var
  a, b: TVector;

begin
  a := TVector.Create(5, 7);
  b := TVector.Create(2, 3);
  VectorToString(a + b);
  VectorToString(a - b);
  VectorToString(a * 11);
  VectorToString(a / 2);

  ReadLn;
end

.
