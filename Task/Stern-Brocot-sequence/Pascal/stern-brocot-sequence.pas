program StrnBrCt;
{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}
const
  MaxCnt = 10835282;{ seq[i] < 65536 = high(Word) }
//MaxCnt = 500*1000*1000;{ 2Gbyte -> real 0.85 s user 0.31 }
type
  tSeqdata =  word;//cardinal LongWord
  pSeqdata = pWord;//pcardinal pLongWord
  tseq = array of tSeqdata;

function SternBrocotCreate(size:NativeInt):tseq;
var
  pSeq,pIns : pSeqdata;
  PosIns : NativeInt;
  sum : tSeqdata;
Begin
  setlength(result,Size+1);
  dec(Size); //== High(result)
  pIns := @result[size];// set at end
  PosIns := -size+2;    // negative index campare to 0
  pSeq := @result[0];

  sum := 1;
  pSeq[0]:= sum;pSeq[1]:= sum;
  repeat
    pIns[PosIns+1] := sum;//append copy of considered
    inc(sum,pSeq[0]);
    pIns[PosIns  ] := sum;
    inc(pSeq);
    inc(PosIns,2);sum := pSeq[1];//aka considered
  until PosIns>= 0;
  setlength(result,length(result)-1);
end;

function FindIndex(const s:tSeq;value:tSeqdata):NativeInt;
Begin
  result := 0;
  while result <= High(s) do
  Begin
    if s[result] = value then
      EXIT(result+1);
    inc(result);
  end;
end;

function gcd_iterative(u, v: NativeInt): NativeInt;
//http://rosettacode.org/wiki/Greatest_common_divisor#Pascal_.2F_Delphi_.2F_Free_Pascal
var
  t: NativeInt;
begin
  while v <> 0 do begin
    t := u;u := v;v := t mod v;
  end;
  gcd_iterative := abs(u);
end;

var
  seq : tSeq;
  i : nativeInt;
Begin
  seq:= SternBrocotCreate(MaxCnt);
// Show the first fifteen members of the sequence.
  For i := 0 to 13 do write(seq[i],',');writeln(seq[14]);
//Show the (1-based) index of where the numbers 1-to-10 first appears in the
  For i := 1 to 10 do
    write(i,' @ ',FindIndex(seq,i),',');
  writeln(#8#32);
//Show the (1-based) index of where the number 100 first appears in the sequence.
  writeln(100,' @ ',FindIndex(seq,100));
//Check that the greatest common divisor of all the two consecutive members of the series up to the 1000th member, is always one.
  i := 999;
  if i > High(seq) then
    i := High(seq);
  Repeat
    IF gcd_iterative(seq[i],seq[i+1]) <>1 then
    Begin
      writeln(' failure at  ',i+1,'  ',seq[i],'  ',seq[i+1]);
      BREAK;
    end;
    dec(i);
  until i <0;
  IF i< 0 then
    writeln('GCD-test is O.K.');
  setlength(seq,0);
end.
