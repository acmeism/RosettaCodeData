 Program SumOfFactors; uses crt; {Perpetrated by R.N.McLean, December MCMXCV}
//{$DEFINE ShowOverflow}
{$IFDEF FPC}
  {$MODE DELPHI}//tested with lots = 524*1000*1000 takes 75 secs generating KnownSum
{$ENDIF}
  var outf: text;
  const Limit = 2147483647;
  const lots = 20000;       {This should be much bigger, but problems apply.}
  var KnownSum: array[1..lots] of longint;
  Function SumF(N: Longint): Longint;
   var f,f2,s,ulp: longint;
   Begin
    if n <= lots then SumF:=KnownSum[N] {Hurrah!}
     else
      begin      {This is really crude...}
       s:=1;     {1 is always a factor, but N is not.}
       f:=2;
       f2:=f*f;
       while f2 < N do
        begin
         if N mod f = 0 then
          begin  {We have a divisor, and its friend.}
           ulp:=f + (N div f);
           if s > Limit - ulp then begin SumF:=-666; exit; end;
           s:=s + ulp;
          end;
         f:=f + 1;
         f2:=f*f;
        end;
        if f2 = N then {A perfect square gets its factor in once only.}
         if s <= Limit - f then s:=s + f
          else begin SumF:=-667; exit; end;
       SumF:=s;
      end;
   End;
  var i,j,l,sf,fs: LongInt;
  const enuff = 666; {Only so much sociability.}
  var trail: array[0..enuff] of longint;
  BEGIN
   ClrScr;
   WriteLn('Chasing Chains of Sums of Factors of Numbers.');
   for i:=1 to lots do KnownSum[i]:=1; {Sigh. KnownSum:=1;}

{start summing every divisor }
   for i:=2 to lots do
    begin
     j:=i + i;
     While j <= lots do    {Sigh. For j:=i + i:Lots:i do KnownSum[j]:=KnownSum[j] + i;}
     begin
       KnownSum[j]:=KnownSum[j] + i;
       j:=j + i;
      end;
    end;

 {Enough preparation.}
   Assign(outf,'Factors.txt'); ReWrite(Outf);
   WriteLn(Outf,'Chasing Chains of Sums of Factors of Numbers.');

   for i:=2 to lots do    {Search.}
    begin
     l:=0;
     sf:=SumF(i);
     while (sf > i) and (l < enuff) do
      begin
       l:=l + 1;
       trail[l]:=sf;
       sf:=SumF(sf);
      end;
     if l >= enuff then writeln('Rope ran out! ',i);
{$IFDEF ShowOverflow}
     if sf < 0 then writeln('Overflow with ',i);
{$ENDIF}
     if i = sf then      {A loop?}
      begin              {Yes. Reveal its members.}
       trail[0]:=i;      {The first.}
       if l = 0 then write('Perfect!! ')
        else if l = 1 then write('Amicable! ')
         else write('Sociable: ');
       for j:=0 to l do Write(Trail[j],',');
       WriteLn;
       if l = 0 then write(outf,'Perfect!! ')
        else if l = 1 then write(outf,'Amicable! ')
         else write(outf,'Sociable: ');
       for j:=0 to l do write(outf,Trail[j],',');
       WriteLn(outf);
      end;
    end;
   Close (outf);
  END.
