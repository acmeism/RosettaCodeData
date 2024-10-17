// This example works on stuff as old as Delphi 5 (maybe older)
// Modern Delphi / Object Pascal has both
//   • generic types
//   • the ability to concatenate arrays with the '+' operator
// So I could just say:
//   myarray := [1] + [2, 3];
// But if you do not have access to the latest/greatest, then:
{$apptype console}

type
  // Array types must be declared in order to return them from functions
  // They can also be used with open array parameters.
  TArrayOfString = array of string;

function Concat( a, b : array of string ): TArrayOfString; overload;
{
  Every array type needs its own 'Concat' function:
    function Concat( a, b : array of integer ): TArrayOfInteger; overload;
    function Concat( a, b : array of double  ): TArrayOfDouble;  overload;
    etc
  Also, dynamic and open array types ALWAYS start at 0. No need to complicate indexing here.
}
var
  n : Integer;
begin
  SetLength( result, Length(a)+Length(b) );
  for n := 0 to High(a) do result[          n] := a[n];
  for n := 0 to High(b) do result[Length(a)+n] := b[n]
end;

// Example time!
function Join( a : array of string; sep : string = ' ' ): string;
var
  n : integer;
begin
  if Length(a) > 0 then result := a[0];
  for n := 1 to High(a) do result := result + sep + a[n]
end;

var
  names : TArrayOfString;
begin
  // Here we use the open array parameter constructor as a convenience
  names := Concat( ['Korra', 'Asami'], ['Bolin', 'Mako'] );
  WriteLn( Join(names) );

  // Also convenient: open array parameters are assignment-compatible with our array type!
  names := Concat( names, ['Varrick', 'Zhu Li'] );
  WriteLn( #13#10, Join(names, ', ') );

  names := Concat( ['Tenzin'], names );
  Writeln( #13#10, Join(names, #13#10 ) );
end.
