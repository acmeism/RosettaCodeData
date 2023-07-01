program HammNumb;
{$IFDEF FPC} {$MODE DELPHI} {$OPTIMIZATION ON,ALL}{$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
type
 tHamNum = record
              hampot : array[0..167] of Word;
              hampotmax,
              hamNum : NativeUint;
            end;
const
 primes : array[0..167] of word =
          (2, 3, 5, 7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71
          ,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151
          ,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233
          ,239,241,251,257,263,269,271,277,281,283,293,307,311,313,317
          ,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419
          ,421,431,433,439,443,449,457,461,463,467,479,487,491,499,503
          ,509,521,523,541,547,557,563,569,571,577,587,593,599,601,607
          ,613,617,619,631,641,643,647,653,659,661,673,677,683,691,701
          ,709,719,727,733,739,743,751,757,761,769,773,787,797,809,811
          ,821,823,827,829,839,853,857,859,863,877,881,883,887,907,911
          ,919,929,937,941,947,953,967,971,977,983,991,997);
var
  HNum:tHamNum;

procedure OutHamNum(const HNum:tHamNum);
var
 i : NativeInt;
Begin
 with Hnum do
 Begin
   write(hamNum:12,' : ');
   For i := 0 to hampotmax-1 do
   Begin
     if hampot[i] >0 then
       if hampot[i] = 1 then
         write(primes[i],'*')
       else
         write(primes[i],'^',hampot[i],'*');
   end;
   if hampot[hampotmax] >0 then
   begin
     write(primes[hampotmax]);
     if hampot[hampotmax] > 1 then
       write('^',hampot[hampotmax]);
   end;
 end;
 writeln;
end;

procedure NextHammNum(var HNum:tHamNum;maxP:NativeInt);
var
 q,p,nr,n,pIdx,momPrime : NativeUInt;
begin
 //special case prime = 2
 IF maxP = 0 then
 begin
   IF HNum.hampot[0] <> 0 then
     HNum.hamNum *= 2
   else
     HNum.hamNum := 1;
   inc(HNum.hampot[0]);
   EXIT;
 end;

 n := HNum.hamNum;
 repeat
   inc(n);
   nr := n;
   pIdx := 0;
   repeat
     momPrime := primes[pIdx];
     q := nr div momPrime;
     p := 0;
     While q*momPrime=nr do
     Begin
       inc(p);
       nr := q;
       q := nr div momPrime;
     end;
     HNum.hampot[pIdx] := p;
     inc(pIdx);
   until (nr=1) OR (pIdx > maxp)
   //found one, than finished
 until nr = 1;

 With HNum do
 Begin
   hamNum := n;
   hamPotmax := pIdx-1;
 end;
end;

procedure OutXafterYSmooth(X,Y,SmoothIdx: NativeUInt);
var
 i: NativeUint;
begin
 IF SmoothIdx> High(primes) then
   EXIT;
 fillChar(HNum,SizeOf(HNum),#0);


 i := 0;
 While HNum.HamNum < Y do
   NextHammNum(HNum,SmoothIdx);

 write('first ',X,' after ',Y,' ',primes[SmoothIdx]:3,'-smooth numbers : ');
 IF x >10 then
   writeln;

 for i := 1 to X-1 do
 begin
   write(HNum.HamNum,' ');
   NextHammNum(HNum,SmoothIdx);
 end;
 writeln(HNum.HamNum,' ');
end;

var
 j: NativeUint;
Begin
 j := 0;
 while primes[j] <= 29 do
 Begin
   OutXafterYSmooth(25,1,j);
   inc(j);
 end;
 writeln;

 j := 1;
 while primes[j] <= 29 do
 Begin
   OutXafterYSmooth(3,3000,j);
   inc(j);
 end;
 writeln;

 while primes[j] < 503 do
   inc(j);
 while primes[j] <= 521 do
 Begin
   OutXafterYSmooth(20,30000,j);
   OutHamNum(Hnum);
   inc(j);
 end;
 writeln;
End.
