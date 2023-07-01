program HofStadterConway;
const
  Pot2 = 20;// tested with 30 -> 4 GB;
type
  tfeld = array[0..1 shl Pot2] of LongWord;
  tpFeld = ^tFeld;
  tMaxPos = record
              mpMax : double;
              mpValue,
              mpPos : longWord;
            end;
  tArrMaxPos = array[0..Pot2-1] of tMaxPos;
var
  a : tpFeld;
  MaxPos : tArrMaxPos;

procedure Init(a:tpFeld);
var
  n,k: LongWord;
begin
  a^[1]:= 1;
  a^[2]:= 1;
  //a[n] := a[a[n-1]]+a[n-a[n-1]];
  //k := a[n-1]
  k := a^[2];
  For n := 3 to High(a^) do
  Begin
    k := a^[k]+a^[n-k];
    a^[n] := k;
  end;
end;

function GetMax(a:tpFeld;starts,ends:LongWord):tMaxPos;
var
  posMax : LongWord;
  r,
  max : double;
Begin
  posMax:= starts;
  max := 0.0;
  repeat
    r := a^[starts]/ starts;
    IF max < r then
    Begin
      max := r;
      posMax := starts;
    end;
    inc(starts);
  until starts >= ends;
  with GetMax do
  Begin
    mpPos:= posMax;
    mpValue := a^[posMax];
    mpMax:= max;
  end;
end;

procedure SearchMax(a:tpFeld);
var
  ends,idx : LongWord;
begin
  idx := 0;
  ends := 2;
  while ends <=  High(a^) do
  Begin
    MaxPos[idx]:=GetMax(a,ends shr 1,ends);
    ends := 2*ends;
    inc(idx);
  end;
end;

procedure OutputMax;
var
  i : integer;
begin
  For i := Low(MaxPos) to High(MaxPOs)  do
    with MaxPos[i] do
    Begin
      Write('Max between 2^',i:2,' and 2^',i+1:2);
      writeln(mpMax:14:11,' at ',mpPos:9,' value :',mpValue:10);
    end;
  writeln;
end;

function SearchLastPos(a:tpFeld;limit: double):LongInt;
var
  i,l : LongInt;
Begin
  Limit := limit;
  IF (Limit>1.0 ) OR (Limit < 0.5) then
  Begin
    SearchLastPos := -1;
    EXIT;
  end;

  i := 0;
  while (i<=High(MaxPos)) AND  (MaxPos[i].mpMax > Limit) do
    inc(i);
  dec(i);
  l := MaxPos[i].mpPos;
  i := 1 shl (i+1);
  while (l< i) AND (a^[i]/i < limit)  do
    dec(i);
  SearchLastPos := i;
end;

var
  p : Pointer;
  l : double;
Begin
  //using getmem because FPCs new is limited to 2^31-1 Byte for the test 2^30 )
  getmem(p,SizeOf(tfeld));
  a := p;
  Init(a);
  SearchMax(a);
  outputMax;
  l:= 0.55;
  writeln('Mallows number with limit ',l:10:8,' at ',SearchLastPos(a,l));
  freemem(p);
end.
