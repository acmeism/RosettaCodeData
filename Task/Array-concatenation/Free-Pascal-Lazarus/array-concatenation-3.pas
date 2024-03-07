Program arrayConcat;

{$mode delphi}

type
    TDynArr = array of integer;

var
  i: integer;
  arr1, arr2, arrSum : TDynArr;

begin
  arr1 := [1, 2, 3];
  arr2 := [4, 5, 6];

  arrSum := arr1 + arr2;

  for i in arrSum do
    write(i, ' ');
  writeln;
end.
