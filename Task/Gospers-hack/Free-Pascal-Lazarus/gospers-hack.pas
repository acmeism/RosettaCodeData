program Gosper;

function NextGosper(mySet:int32):int32;
var
  c,r:Int32;
begin
  c := mySet AND (- mySet);
  r := mySet + c;
  NextGosper := (((r XOR mySet) shr 2)DIV c) OR r;
end;

const
  MAXCnt = 10;
var
  BitCnt,
  mySet,
  cnt :Int32;
BEGIN
  For BitCnt := 1 to 4 do
  Begin
    //minimal number with BitCnt bits set
    mySet := (1 shl BitCnt)-1;
    write(myset : 3,': ');
    For Cnt := 1 to MAXCnt-1 do
    Begin
      mySet := NextGosper(mySet);
      write(mySet,',');
    End;
    mySet := NextGosper(mySet);
    writeln(mySet);
  End;
END.
