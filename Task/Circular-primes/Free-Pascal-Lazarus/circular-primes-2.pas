program CircularPrimes;
//nearly the way it is done:
//http://www.worldofnumbers.com/circular.htm

{$IFDEF FPC}
  {$Release}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$Coperators ON}
//  {$O+,R+}
  uses
    Sysutils,gmp;
{$ENDIF}
{$IFDEF Delphi}
  uses
    System.Sysutils,?gmp?;
{$ENDIF}

{$IFDEF WINDOWS}
   {$APPTYPE CONSOLE}
{$ENDIF}
const
  Pot10 :array[0..19] of Uint64 =
      (1,10,100,1000,10000,100000,1000000,
      10000000,100000000,1000000000,10000000000,100000000000,1000000000000,10000000000000,
      100000000000000,1000000000000000,10000000000000000,100000000000000000,1000000000000000000,10000000000000000000);
  MAXCNTOFDIGITS = 19;

type
  tDigits = 0..9;
  tUsedDigits = set of tDigits;
  tmyNum = record
              Dgts: array[0..MAXCNTOFDIGITS] of tDigits;
              num : Uint64;
              UsedDgt : tUsedDigits;
           end;

var
  CheckNum : array[0..MAXCNTOFDIGITS] of Uint64;
  Found : array[0..23] of Uint64;
  mpz : mpz_t;
  cntPrmTest,
  cntRot : Uint64;
  SolCount : Int32;

  procedure ExtendRepUnit(var mpz:mpz_t;idx1,idx2:Int32);
  begin
    inc(idx1);
    dec(idx2,9);
    while idx1 < idx2 do
    begin
      mpz_mul_ui(mpz,mpz,1000000000);// 2020 Windows only uses Uint32
      mpz_add_ui(mpz,mpz,0111111111);
      inc(idx1,9);
    end;
    inc(idx2,9);
    For idx1 := idx1 to idx2 do
    begin
      mpz_mul_ui(mpz,mpz,10);
      mpz_add_ui(mpz,mpz,1);
    end;
  end;

  procedure CheckOne(MaxIdx:integer);
  begin
    MaxIdx -= 1;
    Found[SolCount] := CheckNum[MaxIdx];
    repeat
      mpz_set_ui(mpz,CheckNum[MaxIdx]);
      If mpz_probab_prime_p(mpz,3)=0then
        EXIT;
      inc(cntPrmTest);
      dec(MaxIdx);
    until MaxIdx < 0;
    inc(SolCount);
  end;

  procedure InitNum(var myNum:tmyNum;maxDgt:Int32);
  var
    i: Int32;
  begin
    fillchar(myNum,SizeOf(myNum),#0);
    with myNum do
    Begin
      num := 0;
      For i := 0 to MaxDgt-1 do
      begin
        Dgts[i] := 1;
        num += Pot10[i];
      end;
    end;
  end;

  procedure CorrectNum(var myNum:tmyNum;maxIdx,idx:Int32);
  var
    n : Uint64;
    dgt :int32;
  begin
    with myNum do
    begin
      dec(MaxIdx);
      dgt := Dgts[maxIdx];
      n := 0;
      while maxIdx>idx do
      Begin
        n += Dgts[maxIdx]*Pot10[maxIdx];
        dec(maxIdx);
      end;
      For Idx := Idx downto 0 do
      Begin
        Dgts[idx]:= dgt;
        n += Dgt*Pot10[Idx];
      end;
      num := n;
    end;
  end;

  function IncNum(var myNum:tmyNum;maxDgt:Int32):boolean;
  //Next number with only digits of 1,3,7,9
  var
    n :Uint64;
    i,dgt: Int64;
    Udgt : tusedDigits;
  begin
    with myNum do
    Begin
      n := num;
      i := 0;
      repeat
        dgt := Dgts[i];
        dgt +=2;
        n += 2*Pot10[i];
        if dgt = 5 then
        begin
          dgt := 7;
          n += 2*Pot10[i];
        end;
        if dgt < 10 then
        begin
          Dgts[i] := dgt;
          Break;
        end;
        //correct values
        Dgts[i] := 1;
        dec(n,Pot10[i]*10);
        inc(i);
      until i >= maxDgt;
      if i >= maxDgt then
        EXIT(false);

      dgt := Dgts[maxDgt-1];
      if dgt > 1 then
      Begin
        i := maxDgt-2;
        while i >= 0 do
        begin
          if Dgts[i]< dgt then
          begin
            //311->333 // 91111 -> 99999
            CorrectNum(myNum,maxDgt,i);
            EXIT(true);
          end;
          dec(i);
        end;
      end;
      num := n;
    end;
    result := true;
  end;

  function rotateNum(n:Uint64;maxDgt:Int32):boolean;
  //rotate number and check divisibility by 3 and 7
  var
    Pot,q ,dgt,n0: Uint64;
  begin
    n0 := n;
    if n0 mod 3 = 0 then
      exit(false);
    if n0 mod 7 = 0 then
      exit(false);

    dec(maxDgt);
    CheckNum[maxDgt] := n;
    Pot := Pot10[maxDgt];
    while maxDgt>0 do
    Begin
      inc(cntRot);
      q := n div 10;
      //last dgt = n mod 10
      dgt := n - 10*q;
      n := dgt*Pot+q;
      //tested elsewhere before
      if n < n0 then
        exit(false);

      if n mod 7 = 0 then
        exit(false);
      dec(maxDgt);
      CheckNum[maxDgt] := n;
    end;
    result := true;
  end;

var
  myNum : TmyNum;
  s :AnsiString;
  T0: Int64;
  idx,idx2 : NativeInt;
begin
  T0 := GetTickCount64;
  mpz_init(mpz);

  SolCount := 0;
  //one digit primes including 5
  For idx := 2 to 10 do
    if idx in[2,3,5,7] then
    begin
      Found[SolCount]:= Idx;
      inc(SolCount);
    end;

  writeln(' search for circular Primes');
  writeln(' digits  found  rotated numbers     to test  time in ms ');
  cntPrmTest := 0;
  cntRot := 0;
  For idx := 2 to 16 do
  begin
    InitNum(myNum,idx);
    repeat
      if rotateNum(myNum.num,idx) then
        CheckOne(idx);
    until Not(IncNUm(myNum,idx));
    writeln(idx:7,Solcount:7,cntRot:17,cntPrmTest:12,GetTickCount64-T0:8);
  end;

  writeln;
  writeln('Found these ',solcount,' circular primes: ');
  For idx := 0 to solCount-2 do
    write(Found[idx],',');
  writeln(Found[solCount-1]);

  mpz_set_ui(mpz,1);
  For idx := 2 to 1031 do
  begin
    mpz_mul_ui(mpz,mpz,10);
    mpz_add_ui(mpz,mpz,1);
    if mpz_probab_prime_p(mpz,1)=1 then
      writeln('Found prime RepUnit(',idx,')');
  end;
(*
  idx := 1031;idx2 := 5003;
  ExtendRepUnit(mpz,idx,idx2);
  write(' Found prime RepUnit(',idx2,')');
  writeln(boolean(Ord(mpz_probab_prime_p(mpz,1))));
  idx := idx2;idx2 := 9887;
  ExtendRepUnit(mpz,idx,idx2);
  write(' Found prime RepUnit(',idx2,')');
  writeln(boolean(Ord(mpz_probab_prime_p(mpz,1))));
  idx := idx2;idx2 := 15073;
  ExtendRepUnit(mpz,idx,idx2);
  write(' Found prime RepUnit(',idx2,')');
  writeln(boolean(Ord(mpz_probab_prime_p(mpz,1))));
  idx := idx2;idx2 := 15073;
  ExtendRepUnit(mpz,idx,idx2);
  write(' Found prime RepUnit(',idx2,')');
  writeln(boolean(Ord(mpz_probab_prime_p(mpz,1))));
  idx := idx2;idx2 := 25031;
  ExtendRepUnit(mpz,idx,idx2);
  write(' Found prime RepUnit(',idx2,')');
  writeln(boolean(Ord(mpz_probab_prime_p(mpz,1))));
  idx := idx2;idx2 := 35317;
  ExtendRepUnit(mpz,idx,idx2);
  write(' Found prime RepUnit(',idx2,')');
  writeln(boolean(Ord(mpz_probab_prime_p(mpz,1))));
  idx := idx2;idx2 := 49081;
  ExtendRepUnit(mpz,idx,idx2);
  write(' Found prime RepUnit(',idx2,')');
  writeln(boolean(Ord(mpz_probab_prime_p(mpz,1))));
// real  8m9,733s
*)
  mpz_clear(mpz);
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
end.
