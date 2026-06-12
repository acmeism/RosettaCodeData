program Find_prime_numbers_of_the_form_n_n_n_plus_2;
{$IFDEF FPC}
  {$MODE DELPHI} {$Optimization ON,ALL} {$COPERATORS ON}{$CODEALIGN proc=16}
{$ENDIF}
{$IFDEF WINDOWS}
   {$APPTYPE CONSOLE}
{$ENDIF}
uses
  PrimTrial;
type
  myString = String[31];

function Numb2USA(n:Uint64):myString;
const
//extend s by the count of comma to be inserted
  deltaLength : array[0..24] of byte =
    (0,0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7);
var
  pI :pChar;
  i,j : NativeInt;
Begin
  str(n,result);
  i := length(result);
 //extend s by the count of comma to be inserted
// j := i+ (i-1) div 3;
  j := i+deltaLength[i];
  if i<> j then
  Begin
    setlength(result,j);
    pI := @result[1];
    dec(pI);
    while i > 3 do
    Begin
       //copy 3 digits
       pI[j] := pI[i];
       pI[j-1] := pI[i-1];
       pI[j-2] := pI[i-2];
       // insert comma
       pI[j-3] := ',';
       dec(i,3);
       dec(j,4);
    end;
  end;
end;

function n3_2(n:Uint32):Uint64;inline;
begin
  n3_2 := UInt64(n)*n*n+2;
end;

const
  limit =200;//trunc(exp(ln((HIGH(UInt32)-2))/3));

var
  p : Uint64;
  n : Uint32;
begin
  n := 1;
  repeat
    p := n3_2(n);
    if isPrime(p) then
      writeln('n = ', Numb2USA(n):4, ' => n^3 + 2 = ', Numb2USA(p): 10);
    inc(n,2);// n must be odd for n > 0
  until n > Limit;
  {$IFDEF WINDOWS}
  readln;
  {$IFEND}
end.
