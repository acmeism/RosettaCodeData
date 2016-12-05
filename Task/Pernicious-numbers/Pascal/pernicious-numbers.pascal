program pernicious;
{$IFDEF FPC}
   {$OPTIMIZATION ON,Regvar,ASMCSE,CSE,PEEPHOLE}// 3x speed up
{$ENDIF}
uses
  sysutils;//only used for time

type
  tbArr    = array[0..64] of byte;
{
  PrimeTil64 : array[0..64] of byte =
  (0,0,2,3,0,5,0, 7,0,0,0,11,0,13,0,0,0,17,0,19,0,0,0,23,0,0,0,0,0,29,0,
    31,0,0,0,0,0,37,0,0,0,41,0,43,0,0,0,47,0, 0,0,0,0,53,0,0,0,0,0,59,0,
    61,0,0,0);
}
const
  PrimeTil64 : tbArr =
  (0,0,1,1,0,1,0, 1,0,0,0,1,0,1,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0,
     1,0,0,0,0,0, 1,0,0,0,1,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,
     1,0,0,0);

function n_beyond_k(n,k: NativeInt):Uint64;
var
  i : NativeInt;
Begin
  result := 1;
  IF 2*k>= n  then
    k := n-k;
  For i := 1 to k do
  Begin
    result := result *n DIV i;
    dec(n);
  end;
end;

function popcnt32(n:Uint32):NativeUint;
//https://en.wikipedia.org/wiki/Hamming_weight#Efficient_implementation
const
  K1  = $0101010101010101;
  K33 = $3333333333333333;
  K55 = $5555555555555555;
  KF1 = $0F0F0F0F0F0F0F0F;
begin
  n := n- (n shr 1) AND NativeUint(K55);
  n := (n AND NativeUint(K33))+ ((n shr 2) AND NativeUint(K33));
  n := (n + (n shr 4)) AND NativeUint(KF1);
  n := (n*NativeUint(K1)) SHR 24;
  popcnt32 := n;
end;

var
  bit1cnt,
  k : LongWord;
  PernCnt : Uint64;
Begin
  writeln('the 25 first pernicious numbers');
  k:=1;
  PernCnt:=0;
  repeat
    IF PrimeTil64[popCnt32(k)] <> 0 then Begin
      inc(PernCnt); write(k,' ');end;
    inc(k);
  until PernCnt >= 25;
  writeln;

  writeln('pernicious numbers in [888888877..888888888]');
  For k :=  888888877 to 888888888 do
    IF PrimeTil64[popCnt32(k)] <> 0  then
      write(k,' ');
  writeln(#13#10);

  k := 8;
  repeat
    PernCnt := 0;
    For bit1cnt := 0 to k do
    Begin
      //i == number of Bits set,n_beyond_k(k,i) == number of arrangements
      IF PrimeTil64[bit1cnt] <> 0 then
        inc(PernCnt,n_beyond_k(k,bit1cnt));
    end;
    writeln(PernCnt,' pernicious numbers in [0..2^',k,'-1]');
    inc(k,k);
  until k>64;
end.
