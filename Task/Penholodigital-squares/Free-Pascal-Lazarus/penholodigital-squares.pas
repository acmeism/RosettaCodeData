program PenHoloLaz;
{$COPERATORS ON}
{$OPTIMIZATION ON,ALL}
{$MODE Delphi}
{$INLINE ON}
//{$R+,O+}
uses
  sysutils;
const
  CnvChar = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
type
  tByteToBinTbl = Array[0..256-1] of Uint64;


  tDigits = array[0..31] of byte;
  tmyString = string[31];
  tmySet = Uint32;
  tLowSqrMasks = array of  tMySet;
  tmyCompound = record
                  mcLower_n2,
                  mcUpper_n2,
                  mcStartN,
                  mcEndN,
                  mcSteps,
                  mcSplitFact,
                  mcCheckLimit : Uint64;
                  mcbase,
                  mcStepSize,
                  mcSplitDgtPos,
                  mcPreTestDgtPos  : Uint32;
                  mcMaskUpper : tMySet;
                  mcMaskUpperOK  :boolean;
                end;

  Function CheckSqrPenholo(n:Uint64;base: Uint32):tmySet;forward;

var
  ByteToBinTbl : tByteToBinTbl;
  LowSqrMasks:tLowSqrMasks;
  FirstSol,LastSol,
  FirstSol_u,LastSol_u,
  SolCnt:Uint64;
  dgtInBase:tDigits;
  StepSize : Uint32;
  myMaskAll: tmySet;


  procedure InitByteToBin(var tbl:tByteToBinTbl);
  var
//  Test: String[8];
    Lmt,Mask,idx,idx1 : Uint64;
  begin
    Mask := Ord('0');
    idx := 8;
    repeat
      Mask := Mask shl idx + Mask;
      idx +=idx;
    until idx >= 64;
    TBL[0] := Mask;
//  TBL[0] = '00000000'
    Lmt := 1;
    //little endian
    Mask := 1 shl 56;
    //big endian  Mask := 1;
    repeat
      idx := 0;
      idx1 := Lmt;
      repeat
        Tbl[idx1] := tbl[idx] OR Mask;// set Bit "0" ->"1"
        inc(idx);
        inc(idx1);
      until idx = Lmt;
      //little endian
      Mask := Mask shr 8;
      //big endian  Mask := Mask shl 8;
      Lmt += Lmt;
   until Lmt >= 256;
  end;

function Numb2Bin(n:Uint64;dgts:Byte):Ansistring;
var
  idx: NativeInt;
begin
  dgts := (dgts-1) AND 7;
  idx := (dgts+1)*9;
  setlength(result,idx);
  fillchar(result[1],idx,#32);

  idx -= 8;
  For dgts := dgts downto 0 do
  begin
    pUint64(@Result[idx])^ := ByteToBinTbl[n and 255];
    idx -= 9;
    n := n shr 8;
  end;
end;

function Numb2USA(n:Uint64):Ansistring;
var
  pI :pChar;
  i,j : NativeInt;
Begin
  str(n,result);
  i := length(result);
 //extend s by the count of comma to be inserted
  j := i+ (i-1) div 3;
  if i<> j then
  Begin
    setlength(result,j);
    pI := @result[1];
    dec(pI);
    while i > 3 do
    Begin
       //copy 3 digits
       pI[j] := pI[i];pI[j-1] := pI[i-1];pI[j-2] := pI[i-2];
       // insert comma
       pI[j-3] := ',';
       dec(i,3);
       dec(j,4);
    end;
  end;
end;

function CalcStepSize(Base:Uint32):Uint32;
var
  dgtSqrRoot : array[0..31] of Uint32;
  dgtRoot,i,j,StepSize:Uint32;
begin
  fillchar(dgtSqrRoot,SizeOf(dgtSqrRoot),#0);
  // make Base to Base-1
  Base := Base-1;
  For i := 1 to Base do
    dgtSqrRoot[i] := sqr(i) MOD Base;
  dgtRoot :=(((Base+1)*Base) DIV 2) MOD Base;
//calc step size i
  i := 0;
  For j := 1 to Base do
    if dgtSqrRoot[j] = dgtRoot then
      inc(i);
  if i <> 0 then
    StepSize := Base DIV i
  else
    StepSize := 1;//pandigital/penholodigital for bases > 2 not possible
  exit(StepSize);
end;

function AdjustN(n: UInt64;Base:Uint32):Uint64;
//increment n til it fits (n*n) MOD b1 = dgtroot
var
  dgtroot,nm,i:Uint64;
begin
  Base := Base-1;
  nm := n MOD Base;
  //sum of digits (0..Base-1) mod (Base-1)
  dgtRoot :=(((Base+1)*Base) DIV 2) MOD Base;
  For i := 1 to Base do
  Begin
    if sqr(nm) MOD Base = dgtroot then
      BREAK;
    inc(nm);
    if nm >= Base then
      nm -= Base;
    inc(n);
  end;
  Exit(n);
end;

function CalcStartNStepSize(Base:Uint32):Uint64;
var
  j : Uint32;
  n : UInt64;
begin
  StepSize := CalcStepSize(Base);
  // square number containing 1,2..,base-1
  // now estimate root for  1234..Base-1
  // if base is even then root = 111...1 in Base
  n := 0;
  For j := Base DIV 2 downto 1 do
    n := n*base+1;
  // if base is  odd then root = sqrt(base)*(111...1) in Base
  if ODD(BASE) then
    n := trunc(n*Sqrt(base));
  Exit(AdjustN(n,base));
end;

function SetLimit(Base:Uint32):Uint64;
//create max penholo square. ex: Base 10 => 987,654,321
//neglectible against '999,999,999'
var
  lmt_f,Base_f : double;
  i : Int32;
begin
  If Base = 2 then
    EXIT(1);
  lmt_f := 0.0;
  Base_f := Base;
  i := Base-1;
  while i>0 do
  Begin
    lmt_f := lmt_f*Base_f+i;
    dec(i);
  end;
  Exit(trunc(sqrt(lmt_f)));
end;

Function DigitsInBase(n:UInt64;base:Uint32):Uint32;
var
  q : UInt64;
  r,idx  : UInt32;
Begin
  fillchar(dgtInBase,SizeOf(DgtInBase),#0);
  idx := 0;
  repeat
    q := n div Base;
    r := n-q*Base;
    dgtInBase[idx] := r;
    inc(idx);
    n := q;
  until q = 0;
  exit(idx-1);
end;

function OutNInBase(n:UInt64;base:Uint32):tmyString;
var
  l : Int32;
Begin
  l := DigitsInBase(n,Base);
  setlength(result,l+1);
  Base := 1;
  repeat
    result[Base]:= CnvChar[dgtInBase[l]+1];
    inc(Base);
    dec(l);
  until l < 0;
end;

procedure OutFromToSol(Base:Uint32);
var
  Outs,Outn : tmyString;
begin
  OutS := OutNInBase(Sqr(FirstSol),Base);
  Outn := OutNInBase(FirstSol,Base);
  write(OutN:Base SHR 1+1,'^2 =',OutS:Base,' .... ');
  OutS := OutNInBase(sqr(LastSol),Base);
  Outn := OutNInBase(LastSol,Base);
  writeln(OutN:Base SHR 1+1,'^2 =',OutS:Base);
end;

procedure OutSolution(n:Uint64;Base:Uint32);
var
  Outs,Outn : tmyString;
begin
  OutS := OutNInBase(sqr(n),Base);
  Outn := OutNInBase(n,Base);
  write(OutN:Base SHR 1+1,'^2 =',OutS:Base,'|');
  if SolCnt mod 4 = 0 then
    writeln;
end;

procedure OutSol(n:Uint64;Base:Uint32);
var
  sc : Uint32;
begin
  sc := SolCnt;
  SolCnt:= sc+1;
  if Base > 10 then
  begin
    if sc <> 0 then
      LastSol := n
    else
      FirstSol := n;
   end
 else
   OutSolution(n,Base);
end;

procedure OutHeader(n,Lmt:Uint64;base:Uint32);
var
  steps : Uint64;
Begin
  steps := (LMT-N) div StepSize;
  write('Base ',base:2,' test from  ',OutNInBase(n,base),' to ');
  writeln(OutNInBase(Lmt,base),' with step size ',StepSize,' -> ',steps,' steps');
end;

 function NewUpperMask(n_u:Uint64;base:Uint32):Uint32;
var
  q : Uint64;
  msk,
  StartMask:UInt32;
begin
  StartMask := 1;
  repeat
    q := n_u div Base;
    msk := 1 shl (n_u - q* base);//dgt;
    if (msk AND StartMask) <> 0 then
      EXIT(0);
    StartMask:= StartMask OR msk;
    n_u := q;
  until q = 0;
  Exit(StartMask);
end;

Procedure OutNewSolHighBase(n:Uint64;base:Uint32);
var
  OutU,OutL : tmyString;
begin
  OutU := OutNInBase(FirstSol_u,Base);
  OutL := OutNInBase(FirstSol,Base);
  write('From ',OutU,OutL,' to ');
  OutU := OutNInBase(LastSol_u,Base);
  OutL := OutNInBase(LastSol,Base);
  writeln(OutU,OutL);
end;

Procedure OutNewSol(n:Uint64;base:Uint32);
var
  OutU,OutL,Outn : tmyString;
begin
  Outn := OutNInBase(n,Base);
  OutU := OutNInBase(LastSol_u,Base);
  OutL := OutNInBase(LastSol,Base);
  write(OutN:Base SHR 1+1,'^2 =',OutU,OutL,'|');
  if SolCnt mod 2 = 0 then
    writeln;
end;

procedure OutSol2(n,n_u,n_l:Uint64;base:Uint32);
var
  sc : Uint32;
begin
  sc := SolCnt;
  LastSol := n_l;
  LastSol_u := n_u;
  if sc = 0 then
  begin
    FirstSol := n_l;
    FirstSol_u := n_u;
  end;
  if base < 11 then
    OutNewSol(n,base);
  SolCnt := sc+1;
end;


Function CheckNewPenholo(n:Uint64;mask:tmySet;base: Uint32):tmySet;inline;
var
  q : UInt64;
  msk  : UInt32;
Begin
  repeat
    q := n div Base;
    msk := 1 shl (n-q*Base);
    if (msk AND mask) <> 0 then
    begin
      mask := 0;
      break;
    end;
    mask := mask XOR msk;
    n := q;
  until q = 0;
  exit(mask);
end;

procedure TestSplitVersion(var myCp:tmyCompound);
var
  dSqr,ddSqr,n2_l,SplitFact: Uint64;
  steps : Int64;
  mask,Base,LowSqrIdx : UInt32;
begin
  If StepSize=1 then
    EXIT;
  with myCp do
  Begin
    SolCnt := 0;
    base := mcbase;
    n2_l := mcLower_n2;
    steps := mcSteps;
    SplitFact := mcSplitFact;
    mcMaskUpper := NewUpperMask(mcUpper_n2,base);
    LowSqrIdx := 0;
    dSqr := (2*mcStartN+StepSize)*Stepsize;
    ddSqr := sqr(StepSize)*2;
    myMaskAll :=(1 shl Base)-1;//b1...11;

    repeat
      repeat
        mask := LowSqrMasks[LowSqrIdx];
        //check if mask of upper digits has no same elemnt of lowSqrDigits
        if mcMaskUpper AND mask = 1 then
        begin
          mask := mcMaskUpper OR mask;
          //check the unchecked digits
          if CheckNewPenholo(n2_l DIV mcCheckLimit,mask,Base) = myMaskAll then
            OutSol2(mcStartN,mcUpper_n2,n2_l,Base);
        end;
        dec(steps);//if steps = 0 then break;
        inc(LowSqrIdx);
        IF LowSqrIdx >= mcCheckLimit then
           dec(LowSqrIdx,mcCheckLimit);
        inc(mcStartN,StepSize);
        inc(n2_l,dSqr);
        inc(dSqr,ddSqr);
      until n2_l >= SplitFact;
      if steps = 0 then
        break;
      repeat
        inc(mcUpper_n2);
        mcMaskUpper := NewUpperMask(mcUpper_n2,base);
        //correct n2_l
        n2_l -= SplitFact;
        if mcMaskUpper = 0 then
        begin
          //next mcUpper_n2 with no tests
          repeat
            dec(steps);
            inc(LowSqrIdx);
            inc(mcStartN,StepSize);
            inc(n2_l,dSqr);
            inc(dSqr,ddSqr);
          until n2_l >= SplitFact;
          while LowSqrIdx >= mcCheckLimit do
            dec(LowSqrIdx,mcCheckLimit);
          if steps <= 0 then
             break;
        end;
      until mcMaskUpper <> 0;
      if steps <= 0 then
         break;
    until false;
    writeln;
    if Base >= 10 then
      OutNewSolHighBase(mcStartN,base);
    writeln(' count ',SolCnt);
  end;
end;

Function CheckGetSqrPenholo(n:Uint64;base,cnt: Uint32):tmySet;
var
  q : UInt64;
  Test, msk: tMySet;
Begin
  Test := 1;
  For cnt := cnt-1 downto 0 do
  Begin
    q := n div Base;
    msk := 1 shl (n-q*Base);
    if (msk AND Test)<> 0 then
      EXIT(0);
    Test := Test OR msk;
    n := q;
  end;
  exit(Test);
end;

  procedure GenerateLowerSqrDigits(var myCb: tmyCompound; Base: uint32);
  var
    n,n_l,j,dSqr,ddSqr : Uint64;
    preTestDgtCnt, i: uint32;
  begin
    n := myCb.mcStartN;
    Writeln(OutNInBase(n,base));
    // only lower part needed
    n_l := myCb.mcLower_n2;
    dSqr := (2*n+StepSize)*Stepsize;
    ddSqr := sqr(StepSize)*2;

    preTestDgtCnt := myCb.mcSplitDgtPos-6;
    j := 1;
    for i := 1 to preTestDgtCnt do
      j *= base;
    myCb.mcPreTestDgtPos := preTestDgtCnt;
    myCb.mcCheckLimit := j;

    setlength(LowSqrMasks,j);
    for i := 0 to j-1 do
    begin
      //Mask for lower digits of square
      LowSqrMasks[i]  := CheckGetSqrPenholo(n_l,base,preTestDgtCnt);
      n_l += dSqr;
      dSqr += ddSqr;
      if n_l >= myCb.mcSplitFact then
        n_l -= myCb.mcSplitFact;
      inc(n,StepSize);
    end;
  Writeln(' ',OutNInBase(n_l,base));
  writeln(OutNInBase(n,base), '  pretestet ',preTestDgtCnt,' digits');
end;

procedure GenerateSplitSqr(var myCb:tmyCompound;Base: Uint32);
// calculate values
//Base 26 is upper limit
(*  tmyCompound = record
                  mcLower_n2,
                  mcUpper_n2,
                  mcStartN,
                  mcEndN,
                  mcSteps,
                  mcSplitFact : Uint64;
                  mcMaskUpper,
                  mcMask      : tmySet;
                  mcbase,
                  mcSplitDgtPos,
                  mcCheckLimit   : Uint32;
                  mcMaskUpperOK  :boolean;
                end;
*)
var
  Digits_N2:tDigits;
  n, baseMod,n_upper,n_lower,DeltaSqr,DeltaDeltaSqr :Uint64;
  i,j,k,DgtJ,dgt,carry : UINt32;
begin
  fillchar(myCb,SizeOF(myCb),#0);
  n := CalcStartNStepSize(base);
  with myCb do
  begin
    mcbase := base;
    mcStartN := n;
    mcEndN := SetLimit(base);
    mcStepSize := CalcStepSize(Base);
    mcSteps := (mcEndN-mcStartN) DIV mcStepSize;
    mcMaskUpper := 1;
    if Base < 10 then
    Begin
      mcLower_n2 := sqr(n);
      mcSplitFact := High(Uint64);
    end;
  end;
  iF StepSize = 1 then
    EXIT;
  DeltaSqr := (2*n+StepSize)*Stepsize;
  DeltaDeltaSqr := sqr(StepSize)*2;

  Writeln(' Base ',base,' starting n in decimal ',Numb2USA(n));
  write  (' DeltaSqr: ',Numb2USA(DeltaSqr));
  Writeln(' DeltaDeltaSqr: ', DeltaDeltaSqr);
  writeln(' Steps: ',Numb2USA(myCb.mcSteps));
// writeln('Is useful ',High(Uint64) div Base > DeltaSqr);


//  if myCb.mcSteps > 60000 then
  Begin
    //do the squaring of n in Base
    fillchar(Digits_N2,SizeOf(Digits_N2),#0);
    k := DigitsInBase(n,base);
    For j := 0 to k do
    Begin
      carry :=0;
      DgtJ := dgtInBase[j];
      For i := 0 to k do
      Begin
        dgt := Digits_N2[i+j] + dgtInBase[i]*DgtJ +Carry;
        carry := dgt DIV Base;
        Digits_N2[i+j] := dgt - carry*Base;
      end;
      if carry <> 0 then
        Digits_N2[j+k+1] += carry;
    end;

    //search for possible position of split digit position
    i := 0;
    baseMod := 1;
    repeat
      baseMod *= Base;
      inc(i);
    until baseMod>=DeltaSqr;

    while High(Int64) DIV baseMod > Base do
    begin
      baseMod *= Base;
      inc(i);
      IF baseMod/DeltaSqr > base then
        Break;
    end;

    myCb.mcSplitDgtPos := i;
    myCb.mcSplitFact := baseMod;
    writeln(' Split at ',i,'  ',NUmb2USA(myCb.mcSplitFact):16,'  ',BaseMod/DeltaSqr:10:7);

    n_upper :=0;
    For j := Base-2 downto i do
      n_upper := n_upper*base+Digits_N2[j];
    n_lower := 0;
    For j := i-1 downto 0 do
      n_lower := n_lower*base+Digits_N2[j];
    write(' ',OutNinBase(n_upper,Base));
    writeln('#',OutNinBase(n_lower,Base));

    with myCb do
    Begin
      mcMaskUpper := NewUpperMask(n_upper,base);
//    writeln(' MaskUpper ',Numb2Bin(mcMaskUpper,3));
      mcMaskUpperOK := mcMaskUpper<>0;
      mcLower_N2 :=n_lower;
      mcUpper_N2 :=n_upper;
    end;

    GenerateLowerSqrDigits(myCb,Base);
  end;
end;

Function CheckSqrPenholo(n:Uint64;base: Uint32):tmySet;
var
  q : UInt64;
  Test : tmySet;
  msk  : tmySet;
Begin
  Test := 1;
  repeat
    q := n div Base;
    msk := 1 shl (n-q*Base);
    if (msk AND Test) <> 0 then
    begin
      Test := 0;
      Break;
    end;
    Test := Test OR msk;
    n := q;
  until q = 0;
  exit(Test);
end;

procedure CheckOneBase(Base:Uint32);
var
  lmt,n,n_sqr,deltaSqr,DeltaDeltaSqr : Uint64;
begin
  // n = sqrt( 12345.. base-1 )
  n := CalcStartNStepSize(Base);
  //if (base = 13) or (base = 17) then    continue;
  If (StepSize = 1) AND (Base<>2) then
    EXIT;
  myMaskAll :=(1 shl Base)-1;//b1...11;
  lmt := SetLimit(Base);
  OutHeader(n,lmt,base);

  FirstSol := 0;
  LastSol := 0;
  //b1...10; 0 marked as already used

  n_sqr := n*n;
  DeltaSqr := (2*n+StepSize)*Stepsize;
  DeltaDeltaSqr := 2*StepSize*Stepsize;
  SolCnt := 0;

  repeat
    If (CheckSqrPenholo(n_sqr,base) XOR myMaskAll) =0 then
      OutSol(n,Base);
    inc(n,StepSize);
    inc(n_sqr,DeltaSqr);
    inc(DeltaSqr,DeltaDeltaSqr);
  until n > Lmt;

  if SolCnt Mod 4 <> 0 then
    writeln;
  Writeln('count: ', SolCnt);
  if (Base >= 11) AND (SolCnt>0) then
    OutFromToSol(Base);
  writeln;
end;

var
  myNum : tmyCompound;
  base : 2..27;
begin
  InitByteToBin(ByteToBinTbl);

//  For base := 10 to 15 do    CheckOneBase(base);

  For base := 16 to 18 do //22 @home
  Begin
    GenerateSplitSqr(myNum,base);
    TestSplitVersion(myNum);
    writeln;
  end;
end.
