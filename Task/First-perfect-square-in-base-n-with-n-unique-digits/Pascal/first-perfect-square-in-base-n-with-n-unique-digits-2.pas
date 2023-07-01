program Pandigital;
//Find the smallest number n to base b, so that n*n includes all
//digits of base b aka pandigital

{$IFDEF FPC}
//{$R+,O+}
  {$MODE DELPHI}
  {$Optimization ON,ALL}
  {$CODEALIGN proc=8,loop=1}// Ryzen Zen loop=1
{$ElSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  {$IFDEF UNIX}
    unix,
    cthreads,
  {$ENDIF}
  gmp,// to calculate start values
  SysUtils;

type
  tRegion32 = 0..31;
  tSolSet32 = set of tRegion32;
  tMask32   = array[tRegion32] of Uint32;
  tpMask32  = ^tMask32;

  tRegion64 = 0..63;
  tSolSet64 = set of tRegion64;
  tMask64   = array[tRegion64] of Uint64;
  tpMask64  = ^tMask64;
const
  // has hyperthreading
  SMT = 0;
{$ALIGN 32}
  //set Bit 0 til Bit 63
  cOr_Mask64: tMask64 =
    (1 shl  0,1 shl  1,1 shl  2,1 shl  3,1 shl  4,1 shl  5,1 shl  6,1 shl  7,
     1 shl  8,1 shl  9,1 shl 10,1 shl 11,1 shl 12,1 shl 13,1 shl 14,1 shl 15,
     1 shl 16,1 shl 17,1 shl 18,1 shl 19,1 shl 20,1 shl 21,1 shl 22,1 shl 23,
     1 shl 24,1 shl 25,1 shl 26,1 shl 27,1 shl 28,1 shl 29,1 shl 30,1 shl 31,
     1 shl 32,1 shl 33,1 shl 34,1 shl 35,1 shl 36,1 shl 37,1 shl 38,1 shl 39,
     1 shl 40,1 shl 41,1 shl 42,1 shl 43,1 shl 44,1 shl 45,1 shl 46,1 shl 47,
     1 shl 48,1 shl 49,1 shl 50,1 shl 51,1 shl 52,1 shl 53,1 shl 54,1 shl 55,
     1 shl 56,1 shl 57,1 shl 58,1 shl 59,1 shl 60,1 shl 61,1 shl 62,1 shl 63);

  charSet: array[0..62] of char =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
type
  tRegion1 = 0..63 - 2 * SizeOf(byte);

  tNumtoBase = packed record
    ntb_dgt: array[tRegion1] of byte;
    ntb_cnt,
    ntb_bas: Byte;
  end;

  tDgtRootSqr = packed record
    drs_List: array[tRegion64] of byte;
    drs_SetOfSol: tSolSet64;
    drs_bas: byte;
    drs_Sol: byte;
    drs_SolCnt: byte;
    drs_Dgt2Add: byte;
    drs_NeedsOneMoreDigit: boolean;
  end;

  tCombineForOneThread = record
    cft_sqr2b,
    cft_deltaNextSqr,
    cft_delta: tNumtoBase;
    cft_count : Uint64;
    cft_offset: Uint64;// unused but doubles speed especially for base 25
    cft_ThreadID: NativeUint;
    cft_ThreadHandle: NativeUint;
    //Alignment = 32
    //Base 25 test every 12    0.539 s Testcount :       78092125
    //Alignment = 24
    //Base 25 test every 12    1.316 s Testcount :       78092125
  end;

  procedure AddNum(var add1: tNumtoBase; const add2: tNumtoBase); forward;
  function AddNumSqr(var add1, add2: tNumtoBase): Uint64;  forward;

var
  ThreadBlocks: array of tCombineForOneThread;
{$ALIGN 32}
  Num, sqr2B, deltaNextSqr, delta: tNumtoBase;
{$ALIGN 32}
  DgtRtSqr: tDgtRootSqr;
{$ALIGN 8}
  gblThreadCount,
  Finished: Uint32;

  function GetCoreCount:NativeInt;
  // from lazarus forum
  var
    t: Text;
    s: string;
  begin
    result := 1;
    try
      POpen(t, 'nproc', 'R');
      while not Eof(t) do
        Readln(t, s);
    finally
      PClose(t);
    end;
    result := StrToInt(s);
  end;

  function GetThreadCount: NativeUInt;
  begin
    {$IFDEF Windows}
      Result := GetCpuCount;
    {$ELSE}
      Result := GetCoreCount;//GetCpuCount is not working under Linux ???
    {$ENDIF}
    if SMT = 1 then
      Result := (Result+1) div 2;
  end;

  procedure OutNum(const num: tNumtoBase);
  var
    i: NativeInt;
  begin
    with num do
    begin
      for i := ntb_cnt - 1 downto 0 do
        Write(charSet[ntb_dgt[i]]);
    end;
    Write(' ');
  end;

  procedure OutNumSqr;
  begin
    Write(' Num ');OutNum(Num);
    Write(' sqr ');OutNum(sqr2B);
    writeln;
  end;

  function getDgtRtNum(const num: tNumtoBase): NativeInt;
  var
    i: NativeInt;
  begin
    with num do
    begin
      Result := 0;
      for i := 0 to num.ntb_cnt - 1 do
        Inc(Result, ntb_dgt[i]);
      Result := Result mod (ntb_bas - 1);
    end;
  end;

  procedure CalcDgtRootSqr(base: NativeUInt);
  var
    ChkSet: array[tRegion64] of tSolSet64;
    ChkCnt: array[tRegion64] of byte;
    i, j: NativeUInt;
    PTest: tSolSet64;
  begin
    for i := low(ChkCnt) to High(ChkCnt) do
    begin
      ChkCnt[i] := 0;
      ChkSet[i] := [];
    end;
    ptest := [];
    with DgtRtSqr do
    begin
      //pandigtal digital root (sum all digits of base) mod (base-1)
      drs_bas := base;
      if Odd(base) then
        drs_Sol := base div 2
      else
        drs_Sol := 0;

      base := base - 1;
      //calc which dgt root the square of the number will become
      for i := 0 to base - 1 do
        drs_List[i] := (i * i) mod base;
      //searching for solution
      drs_SolCnt := 0;
      for i := 0 to base - 1 do
        if drs_List[i] = drs_Sol then
        begin
          include(ptest, i);
          Inc(drs_SolCnt);
        end;
      //if not found then NeedsOneMoreDigit
      drs_NeedsOneMoreDigit := drs_SolCnt = 0;
      if drs_NeedsOneMoreDigit then
      begin
        for j := 1 to Base do
          for i := 0 to Base do
            if drs_List[j] = (drs_Sol + i) mod BASE then
            begin
              include(ptest, i);
              include(ChkSet[i], j);
              Inc(ChkCnt[i]);
            end;
        i := 1;
        repeat
          if i in pTest then
          begin
            drs_Dgt2Add := i;
            BREAK;
          end;
          Inc(i);
        until i > base;
        write(' insert ', i);
      end;
    end;
  end;

  procedure conv_ui_num(base: NativeUint; ui: Uint64; var Num: tNumtoBase);
  var
    i: NativeUInt;
  begin
    for i := 0 to high(tNumtoBase.ntb_dgt) do
      Num.ntb_dgt[i] := 0;
    with num do
    begin
      ntb_bas := base;
      ntb_cnt := 0;
      if ui = 0 then
        EXIT;
      i := 0;
      repeat
        ntb_dgt[i] := ui mod base;
        ui := ui div base;
        Inc(i);
      until ui = 0;
      ntb_cnt := i;
    end;
  end;

  procedure conv2Num(base: NativeUint; var Num: tNumtoBase; var s: mpz_t);
  var
    tmp: mpz_t;
    i: NativeUInt;
  begin
    mpz_init_set(tmp, s);
    for i := 0 to high(tNumtoBase.ntb_dgt) do
      Num.ntb_dgt[i] := 0;
    with num do
    begin
      ntb_bas := base;
      i := 0;
      repeat
        ntb_dgt[i] := mpz_tdiv_q_ui(s, s, base);
        Inc(i);
      until mpz_cmp_ui(s, 0) = 0;
      ntb_cnt := i;
    end;
    mpz_clear(tmp);
  end;

  procedure StartValueCreate(base: NativeUInt);
  //create the lowest pandigital number "102345...Base-1 "
  //calc sqrt +1 and convert n new format.
  var
    sv_sqr, sv: mpz_t;
    k, dblDgt: NativeUint;

  begin
    mpz_init(sv);
    mpz_init(sv_sqr);

    mpz_init_set_si(sv_sqr, base);//"10"
    CalcDgtRootSqr(base);

    if DgtRtSqr.drs_NeedsOneMoreDigit then
    begin
      dblDgt := DgtRtSqr.drs_Dgt2Add;
      if dblDgt = 1 then
      begin
        for k := 1 to base - 1 do
        begin
          mpz_mul_ui(sv_sqr, sv_sqr, base);
          mpz_add_ui(sv_sqr, sv_sqr, k);
        end;
      end
      else
      begin
        for k := 2 to dblDgt do
        begin
          mpz_mul_ui(sv_sqr, sv_sqr, base);
          mpz_add_ui(sv_sqr, sv_sqr, k);
        end;
        for k := dblDgt to base - 1 do
        begin
          mpz_mul_ui(sv_sqr, sv_sqr, base);
          mpz_add_ui(sv_sqr, sv_sqr, k);
        end;
      end;
    end
    else
    begin
      for k := 2 to base - 1 do
      begin
        mpz_mul_ui(sv_sqr, sv_sqr, base);
        mpz_add_ui(sv_sqr, sv_sqr, k);
      end;
    end;

    mpz_sqrt(sv, sv_sqr);
    mpz_add_ui(sv, sv, 1);
    mpz_mul(sv_sqr, sv, sv);

    conv2Num(base, Num, sv);
    conv2Num(base, sqr2B, sv_sqr);

    mpz_clear(sv_sqr);
    mpz_clear(sv);
  end;

  function ExtractThreadVal(ThreadNr: NativeInt ): Uint64;
  begin
    with ThreadBlocks[ThreadNr] do
    begin
      sqr2b := cft_sqr2b;
      Result := cft_count;
      cft_ThreadID := 0;
      cft_ThreadHandle := 0;
    end;
  end;

  function CheckPandigital(const n: tNumtoBase): boolean;
  var
    pMask: tpMask64;
    TestSet: Uint64;
    i: NativeInt;
  begin
    pMask := @cOr_Mask64;
    TestSet := 0;
    with n do
    begin
      for i := ntb_cnt - 1 downto 0 do
        TestSet := TestSet or pMask[ntb_dgt[i]];
      Result := (Uint64(1) shl ntb_bas - 1) = TestSet;
    end;
  end;

  procedure IncNumBig(var add1: tNumtoBase; n: Uint64);
  var
    i, s, b, carry: NativeUInt;
  begin
    b := add1.ntb_bas;
    i := 0;
    carry := 0;
    while n > 0 do
    begin
      s := add1.ntb_dgt[i] + carry + n mod b;
      carry := Ord(s >= b);
      s := s - (-carry and b);
      add1.ntb_dgt[i] := s;
      n := n div b;
      Inc(i);
    end;

    while carry <> 0 do
    begin
      s := add1.ntb_dgt[i] + carry;
      carry := Ord(s >= b);
      s := s - (-carry and b);
      add1.ntb_dgt[i] := s;
      Inc(i);
    end;

    if add1.ntb_cnt < i then
      add1.ntb_cnt := i;
  end;

  procedure IncSmallNum(var add1: tNumtoBase; carry: NativeUInt);
  //prerequisites carry < base
  var
    i, s, b: NativeUInt;
  begin
    b := add1.ntb_bas;
    i := 0;
    while carry <> 0 do
    begin
      s := add1.ntb_dgt[i] + carry;
      carry := Ord(s >= b);
      s := s - (-carry and b);
      add1.ntb_dgt[i] := s;
      Inc(i);
    end;
    if add1.ntb_cnt < i then
      add1.ntb_cnt := i;
  end;

  procedure AddNum(var add1: tNumtoBase; const add2: tNumtoBase);
  //add1 <= add1+add2;
  var
    i, base, s, carry: NativeUInt;
  begin
    carry := 0;
    base := add1.ntb_bas;

    for i := 0 to add2.ntb_cnt - 1 do
    begin
      s := add1.ntb_dgt[i] + add2.ntb_dgt[i] + carry;
      carry := Ord(s >= base);
      s := s - (-carry and base);
      add1.ntb_dgt[i] := s;
    end;

    i := add2.ntb_cnt;
    while carry = 1 do
    begin
      s := add1.ntb_dgt[i] + carry;
      carry := Ord(s >= base);
      s := s - (-carry and base);
      add1.ntb_dgt[i] := s;
      Inc(i);
    end;

    if add1.ntb_cnt < i then
      add1.ntb_cnt := i;
  end;

  procedure Mul_num_ui(var n: tNumtoBase; ui: Uint64);
  var
    dbl: tNumtoBase;
  begin
    dbl := n;
    conv_ui_num(n.ntb_bas, 0, n);
    while ui > 0 do
    begin
      if Ui and 1 <> 0 then
        AddNum(n, dbl);
      AddNum(dbl, dbl);
      ui := ui div 2;
    end;
  end;

  procedure CalcDeltaSqr(const num: tNumtoBase; var dnsq, dlt: tNumtoBase;
    n: NativeUInt);
  //calc  deltaNextSqr   //n*num
  begin
    dnsq := num;
    Mul_num_ui(dnsq, n);
    AddNum(dnsq, dnsq);
    IncNumBig(dnsq, n * n);
    conv_ui_num(num.ntb_bas, 2 * n * n, dlt);
  end;

  procedure PrepareThreads(thdCount,stepWidth:NativeInt);
  //starting the threads at num,num+stepWidth,..,num+(thdCount-1)*stepWidth
  //stepwith not stepWidth but thdCount*stepWidth
  var
    tmpnum,tmpsqr2B,tmpdeltaNextSqr,tmpdelta :tNumToBase;
    i : NativeInt;
  Begin
    tmpnum := num;
    tmpsqr2B := sqr2B;
    tmpdeltaNextSqr := deltaNextSqr;
    tmpdelta := delta;

    For i := 0 to thdCount-1 do
    Begin
      //init ThreadBlock
      With ThreadBlocks[i] do
      begin
        cft_sqr2b := tmpsqr2B;
        cft_count := 0;
        CalcDeltaSqr(tmpnum,cft_deltaNextSqr,cft_delta,thdCount*stepWidth);
      end;
      //Next sqr number in stepWidth
      IncSmallNum(tmpnum,stepWidth);
      AddNumSqr(tmpsqr2B,tmpdeltaNextSqr);
      IF CheckPandigital(sqr2B) then
      begin
        writeln(' solution found ');
        readln;
        Halt(-124);
      end;
      AddNum(tmpdeltaNextSqr,tmpdelta);
    end;
  end;

  function AddNumSqr(var add1, add2: tNumtoBase): Uint64;
  //add1 <= add1+add2;
  //prerequisites bases are the same,add1>=add2( cnt ),
  //out Set of used digits
  var
    pMask: tpMask64;
    i, base, s, carry: NativeInt;
  begin
    pMask := @cOr_Mask64;
    base := add1.ntb_bas;
    dec(s,s);
    Result := s;
    carry := s;

    for i := 0 to add2.ntb_cnt - 1 do
    begin
      s := add1.ntb_dgt[i] + add2.ntb_dgt[i] + carry;
      carry := Ord(s >= base);
      s := s - (-carry and base);
      Result := Result or pMask[s];
      add1.ntb_dgt[i] := s;
    end;

    i := add2.ntb_cnt;
    while carry = 1 do
    begin
      s := add1.ntb_dgt[i] + carry;
      carry := Ord(s >= base);
      s := s - (-carry and base);
      Result := Result or pMask[s];
      add1.ntb_dgt[i] := s;
      Inc(i);
    end;

    if add1.ntb_cnt < i then
      add1.ntb_cnt := i;

    for i := i to add1.ntb_cnt - 1 do
      Result := Result or pMask[add1.ntb_dgt[i]];
  end;

  procedure TestRunThd(parameter: pointer);
  var
    pSqrNum, pdeltaNextSqr, pDelta: ^tNumtoBase;
    TestSet, TestSetComplete, i: Uint64;
    ThreadBlockIdx: NativeInt;
  begin
    ThreadBlockIdx := NativeUint(parameter);
    with ThreadBlocks[ThreadBlockIdx] do
    begin
      pSqrNum       := @cft_sqr2b;
      pdeltaNextSqr := @cft_deltaNextSqr;
      pDelta        := @cft_delta;
    end;
    TestSetComplete := Uint64(1) shl pSqrNum^.ntb_bas - 1;
    i := 0;
    repeat
      //next square number
      TestSet := AddNumSqr(pSqrNum^, pdeltaNextSqr^);
      AddNum(pdeltaNextSqr^, pdelta^);
      Inc(i);
      if finished <> 0 then
        BREAK;
    until TestSetComplete = TestSet;

    if finished = 0 then
    begin
      InterLockedIncrement(finished);
      ThreadBlocks[ThreadBlockIdx].cft_count := i;
      EndThread(i);
    end
    else
      EndThread(0);
  end;

  procedure Test(base: NativeInt);
  var
    stepWidth: Uint64;
    i, j,UsedThreads: NativeInt;
  begin
    write('Base ', base);
    StartValueCreate(base);
    deltaNextSqr := num;
    AddNum(deltaNextSqr, deltaNextSqr);
    IncSmallNum(deltaNextSqr, 1);
    stepWidth := 1;
    if (Base > 4) and not (DgtRtSqr.drs_NeedsOneMoreDigit) then
    begin
      //Find first number which can get the solution
      with dgtrtsqr do
        while drs_List[getDgtRtNum(num)] <> drs_sol do
        begin
          IncSmallNum(num, 1);
          AddNum(sqr2B, deltaNextSqr);
          IncSmallNum(deltaNextSqr, 2);
        end;
      stepWidth := (Base - 1) div DgtRtSqr.drs_SolCnt;
      if stepWidth * DgtRtSqr.drs_SolCnt <> (Base - 1) then
        stepWidth := 1;
    end;
    CalcDeltaSqr(num,deltaNextSqr,delta,stepWidth);
    writeln(' test every ', stepWidth);
//  Write('Start  :');OutNumSqr;
    i := 0;
    if not (CheckPandigital(sqr2b)) then
    begin
      finished := 0;
      j := 0;
      UsedThreads := gblThreadCount;
      if base < 21 then
        UsedThreads := 1;
      PrepareThreads(UsedThreads,stepWidth);
      j := 0;
      while (j < UsedThreads) and (finished = 0) do
      begin
        with ThreadBlocks[j] do
        begin
          cft_ThreadHandle :=
          BeginThread(@TestRunThd, Pointer(j), cft_ThreadID,
              4 * 4096);
        end;
        Inc(j);
      end;
      WaitForThreadTerminate(ThreadBlocks[0].cft_ThreadHandle, -1);
      repeat
        Dec(j);
        with ThreadBlocks[j] do
        begin
          WaitForThreadTerminate(cft_ThreadHandle, -1);
          if cft_count <> 0 then
            finished := j;
        end;
      until j = 0;
      i := ExtractThreadVal(finished);
      j := i*UsedThreads+finished;//TestCount starts at original num
      IncNumBig(num,j*stepWidth);
    end;
    OutNumSqr;
  end;

var
  T: TDateTime;
  base: NativeUint;
begin
  T := now;
  gblThreadCount:= GetThreadCount;
  writeln(' Cpu Count : ', gblThreadCount);
  setlength(ThreadBlocks, gblThreadCount);
  for base := 2 to 28 do
    Test(base);
  writeln('completed in ', (now - T) * 86400: 0: 3, ' seconds');
  setlength(ThreadBlocks, 0);
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
end.
