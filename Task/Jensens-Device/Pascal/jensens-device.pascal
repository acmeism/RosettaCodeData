{$MODE objFPC}
type
  tTerm = function(i: integer):real;

function term(i:integer):real;
Begin
  term := 1/i;
end;

function sum(var i: LongInt;
              lo,hi: integer;
              term:tTerm):real;

Begin
  result := 0;
  i := lo;
  while i<=hi do begin
    result := result+term(i);
    inc(i);
    end;
end;

var
  i : LongInt;
Begin
  writeln(sum(i,1,100,@term));
end.
