program reduce;

type
//  tmyArray = array of LongInt;
  tmyArray = array[-5..5] of LongInt;
  tmyFunc = function (a,b:LongInt):LongInt;

function add(x,y:LongInt):LongInt;
begin
  add := x+y;
end;

function sub(k,l:LongInt):LongInt;
begin
  sub := k-l;
end;

function mul(r,t:LongInt):LongInt;
begin
  mul := r*t;
end;

function reduce(myFunc:tmyFunc;a:tmyArray):LongInt;
var
  i,res : LongInt;
begin
  res := a[low(a)];
  For i := low(a)+1 to high(a) do
    res := myFunc(res,a[i]);
  reduce := res;
end;

procedure InitMyArray(var a:tmyArray);
var
  i: LongInt;
begin
  For i := low(a) to high(a) do
  begin
    //no a[i] = 0
    a[i] := i + ord(i=0);
    write(a[i],',');
  end;
  writeln(#8#32);
end;

var
  ma : tmyArray;
BEGIN
  InitMyArray(ma);
  writeln(reduce(@add,ma));
  writeln(reduce(@sub,ma));
  writeln(reduce(@mul,ma));
END.
