program SubUnitSquares;
{$OPTIMIZATION ON,ALL}
procedure CheckForZero(n,i,j:NativeUint);
var
  q,dgt: NativeUint;
begin
  repeat
    q := n DIV 10;
    dgt := n-10*q;
    if dgt = 0 then
      EXIT;
    n := q
  until q = 0;
  j := (j-1) SHR 1;i := (i-1) SHR 1;
  writeln(j:10,sqr(j):20,' -> ',sqr(i):20,i:10);
end;

var
  sqI,sqJ,dSqrI,dSqrJ,Pot10Limit,RepUnit : NativeUInt;
BEGIN
   Pot10Limit := 10;
   RepUnit := 1;

   sqj := 1;      // 1*1
   sqI := RepUnit;// 0+RepUnit
   dSqrI := 1;
   dSqrJ := 2*1+1;

   repeat
     if sqJ = sqI then
       CheckForZero(sqj,dSqrI,dSqrJ);

     repeat
       sqJ += dSqrJ;
       inc(dSqrJ,2);
     until sqJ>=sqI;

     //one more digit
     if sqJ >= Pot10Limit then
     begin
//     choose dSqrI and sqJ so, that next sqJ starts with digit 2
       RepUnit += Pot10Limit;
       dSqrI := trunc(sqrt(2*Pot10Limit-RepUnit));
       dSqrJ := trunc(sqrt(2*Pot10Limit));
       Pot10Limit *= 10;
       sqI := dSqrI*dSqrI+RepUnit;
       dSqrI := 2*dSqrI+1;
       sqJ := dSqrJ*dSqrJ;
       dSqrJ := 2*dSqrJ+1;
     end;

     repeat
       sqI += dSqrI;
       inc(dSqrI,2);
     until sqI>=sqJ;
   until dSqrJ >2*514567445; //2*2*1000*1000*1000;//
END.
