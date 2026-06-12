program Coprime_triplets;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

//https://rosettacode.org/wiki/Greatest_common_divisor#Pascal_.2F_Delphi_.2F_Free_Pascal
function Gcd(u, v: longint): longint;
begin
  if v = 0 then
    EXIT(u);
  result := Gcd(v, u mod v);
end;

function IsIn(value: Integer; a: TArray<Integer>): boolean;
begin
  for var e in a do
    if e = value then
      exit(true);
  Result := false;
end;

function CoprimeTriplets(less_than: Integer = 50): TArray<Integer>;
var
  cpt: TArray<Integer>;
  _end: Integer;
begin
  cpt := [1, 2];
  _end := high(cpt);

  while True do
  begin
    var m := 1;
    while IsIn(m, cpt) or (gcd(m, cpt[_end]) <> 1) or (gcd(m, cpt[_end - 1]) <> 1) do
      inc(m);
    if m >= less_than then
      exit(cpt);
    SetLength(cpt, Length(cpt) + 1);
    _end := high(cpt);
    cpt[_end] := m;
  end;
end;

begin
  var trps := CoprimeTriplets();
  writeln('Found ', length(trps), ' coprime triplets less than 50:');
  for var i := 0 to High(trps) do
  begin
    write(trps[i]: 2, ' ');
    if (i + 1) mod 10 = 0 then
      writeln;
  end;
  {$IFNDEF UNIX} Readln; {$ENDIF}
end.
