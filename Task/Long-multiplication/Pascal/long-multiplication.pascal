Program TwoUp; Uses DOS, crt;
{Concocted by R.N.McLean (whom God preserve), Victoria university, NZ.}
 Procedure Croak(gasp: string);
  Begin
   Writeln;
   Write(Gasp);
   HALT;
  End;

 const BigBase = 10;		{The base of big arithmetic.}
 const BigEnuff = 333;		{The most storage possible is 65532 bytes with Turbo Pascal.}
 type  BigNumberIndexer = word;	{To access 0:BigEnuff BigNumberDigit data.}
 type  BigNumberDigit = byte;	{The data.}
 type  BigNumberDigit2 = word;	{Capable of digit*digit + carry. Like, 255*255 = 65025}

 type BigNumber =		{All sorts of arrangements are possible.}
  Record				{Could include a sign indication.}
   TopDigit: BigNumberDigit;		{Finger the high-order digit.}
   digit: array[0..BigEnuff] of byte;	{The digits: note the "downto" in BigShow.}
  end;					{Could add fractional digits too. Endless, endless.}

 Procedure BigShow(var a: BigNumber);	{Print the number.}
  var i: integer;	{A stepper.}
  Begin
   for i:=a.TopDigit downto 0 do	{Thus high-order to low, as is the custom.}
    if BigBase = 10 then write(a.digit[i])	{Constant following by the Turbo Pascal compiler}
     else if BigBase = 100 then Write(a.digit[i] div 10,a.digit[i] mod 10)	{Means that there will be no tests.}
      else write(a.digit[i],',');		{And dead code will be omitted.}
  End;

 Procedure BigZero(var A: BigNumber); {A:=0;}
  Begin;
   A.TopDigit:=0;
   A.Digit[0]:=0;
  End;
 Procedure BigOne(var A: BigNumber);  {A:=1;}
  Begin;
   A.TopDigit:=0;
   A.Digit[0]:=1;
  End;
 Function BigInt(n: longint): BigNumber; {A:=N;}
  var l: BigNumberIndexer;
  Begin
   l:=0;
   if n < 0 then croak('Negative integers are not yet considered.');
   repeat		{At least one digit is to be placed.}
    if l > BigEnuff then Croak('BigInt overflowed!');	{Oh dear.}
    BigInt.Digit[l]:=N mod BigBase;	{The low-order digit.}
    n:=n div BigBase;			{Shift down a digit.}
    l:=l + 1;				{Count in anticipation.}
   until N = 0;			{Still some number left?}
   BigInt.TopDigit:=l - 1;	{Went one too far.}
  End;

 Function BigMult(a,b: BigNumber): BigNumber;	{x:=BigMult(a,b);}
{Suppose the digits of A are a5,a4,a3,a2,a1,a0...
 To multiply A and B.
                               a5   a4   a3   a2   a1   a0: six digits, d1
                                x   b4   b3   b2   b1   b0: five digits, d2
                               ---------------------------
                             a5b0 a4b0 a3b0 a2b0 a1b0 a0b0
                        a5b1 a4b1 a3b1 a2b1 a1b1 a0b1
                   a5b2 a4b2 a3b2 a2b2 a1b2 a0b2
              a5b3 a4b3 a3b3 a2b3 a1b3 a0b3
         a5b4 a4b4 a3b4 a2b4 a1b4 a0b4
   -------------------------------------------------------
   carry    9    8    7    6    5    4    3    2    1    0: at least nine digits,
   -------------------------------------------------------  = d1 + d2 - 1
   But the indices are also the powers, so the highest power is 9 = 5 + 4,
and a possible tenth for any carry.}
  var X: BigNumber;		{Scratchpad, so b:=BigMult(a,b); doesn't overwrite b as it goes...}
  var d: BigNumberDigit;	{A digit.}
  var c: BigNumberDigit;	{A carry.}
  var dd: BigNumberDigit2;	{A digit product.}
  var i,j,l: BigNumberIndexer;	{Steppers.}
  Begin
   if ((A.TopDigit = 0) and (A.Digit[0] = 0))
    or((B.TopDigit = 0) and (B.Digit[0] = 0)) then begin BigZero(BigMult); exit; end;
   l:=A.TopDigit + B.TopDigit;       {Minimal digit requirement. (Counting is from zero)}
   if l > BigEnuff then Croak('BigMult will overflow.');
   for i:=l downto 0 do X.Digit[i]:=0;	{Clear for action.}
   for i:=0 to A.TopDigit do		{Arbitrarily, choose A on the one hand.}
    begin				{Though there could be a better choice.}
     d:=A.Digit[i];			{Select the digit.}
     if d <> 0 then			{What the hell. One in BigBase chance.}
      begin				{But not this time.}
       l:=i;				{Locate the power of BigBase.}
       c:=0;				{Start this digit's multiply pass.}
       for j:=0 to B.TopDigit do	{Stepping along B's digits.}
        begin				{One by one.}
         dd:=BigNumberDigit2(B.Digit[j])*d + X.Digit[l] + c;	{The deed.}
         X.Digit[l]:=dd mod BigBase;	{Place the new digit.}
         c:=dd div BigBase;		{And extract the carry.}
         l:=l + 1;			{Ready for the next power up.}
        end;				{Advance to it.}
       if c > 0 then			{The multiply done, place the carry.}
        begin				{Ah. We *will* use the next power up.}
         if l > BigEnuff then Croak('BigMultX has overflowed.');	{Oh dear.}
         X.Digit[l]:=c;		{Thus as if BigMult..Digit[l] was zeroed.}
         l:=l + 1;			{Preserve the one-too-far for the last case}
        end;				{So much for a carry at the end of a pass.}
      end;				{So much for a non-zero digit.}
    end;			{On to another digit to multiply with.}
   X.TopDigit:=l - 1;	{Remember the one-too-far.}
   BigMult:=X;		{Deliver, possibly scragging A or B, or, both!}
 End; {of BigMult.}

 Procedure BigPower(var X: BigNumber; P: longint); {Replaces X by X**P}
  var A,W: BigNumber;	{Scratchpads}
  label up;
  Begin		{Each squaring doubles the power, melding nicely with binary reduction.}
   if P <= 0 then Croak('Negative powers are not accommodated!');
   BigOne(A);		{x**0 = 1}
   W:=X;		{Holds X**1, 2, 4, 8, etc.}
up:if P mod 2 = 1 then A:=BigMult(A,W);	{Bit on, so include this order.}
   P:=P div 2;		{Halve the power contrariwise to W's doubling.}
   if P > 0 then 	{Still some power to come?}
    begin		{Yes.}
     W:=BigMult(W,W);	{Step up to the next bit's power.}
     goto up;		{And see if it is "on".}
    end;		{Odd layout avoids multiply testing P > 0.}
   X:=A;		{The result.}
  End;

 var X: BigNumber;
 var p: longint;
 BEGIN
  ClrScr;
  WriteLn('To calculate  x = 2**64, then x*x via multi-digit long multiplication.');
  p:=64;		{As per the specification.}
  X:=BigInt(2);		{Start with 2.}
  BigPower(X,p);	{First stage: 2**64}
  Write ('x = 2**',p,' = '); BigShow(X);
  WriteLn;
  X:=BigMult(X,X);	{Second stage.}
  Write ('x*x = ');BigShow(X);	{Can't have Write('x*x = ',BigShow(BigMult(X,X))), after all. Oh well.}
 END.
