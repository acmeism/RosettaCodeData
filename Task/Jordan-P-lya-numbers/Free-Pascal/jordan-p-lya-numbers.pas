program Jordan_Polya_Num;
{$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$COPERATORS ON}{$ENDIF}
{$IFDEF Windows}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;
const
  MaxIdx = 3800;//7279 < 2^62
  maxFac = 25;//21!> 2^63
type
  tnum = Uint64;
  tpow= set of 0..31;// 1==2!^? ,2=3!^? 3=2!^?*3!^?
  tFac_mul = packed record
               fm_num : tnum;
               fm_pow : tpow;
               fm_high_idx : word;
               fm_high_pow : word;
             end;
  tpFac_mul = ^tFac_mul;
  tFacMulPow = array of tFac_mul;
  tFactorial = array[0..maxFac-2] of tnum;

var
  FacMulPowGes : tFacMulPow;
  Factorial: tFactorial;
  LastSearchFor :tFac_mul;
  dblLimit : tnum;

function CommatizeUint64(num:Uint64):AnsiString;
var
   fromIdx,toIdx :Int32;
Begin
  str(num,result);
  fromIdx := length(result);
  toIdx := fromIdx-1;
  if toIdx < 3 then
    exit;

  toIdx := 4*(toIdx DIV 3)+toIdx MOD 3 +1 ;
  setlength(result,toIdx);
  repeat
    result[toIdx]   := result[FromIdx];
    result[toIdx-1] := result[FromIdx-1];
    result[toIdx-2] := result[FromIdx-2];
    result[toIdx-3] := ',';
    dec(toIdx,4);
    dec(FromIdx,3);
  until FromIdx<=3;
end;

procedure Out_MulFac(idx:Uint32;const fm:tFac_mul);
var
  fac,
  num : tNum;
  FacIdx,pow : integer;
begin
  num := fm.fm_num;
  FacIdx := fm.fm_high_idx;
  write(CommatizeUint64(num):25,' = ');

  repeat
    pow := 0;
    fac := Factorial[FacIdx];
    while (num>=fac) AND (num mod Fac = 0) do
    Begin
      num := num DIV Fac;
      inc(pow);
    end;
    if pow = 0 then
      write(' 1')
    else
      if pow = 1 then
        write(' ',FacIdx+2,'!')
      else
        write(' (',FacIdx+2,'!)^',pow);
    if num = 1 then
      BREAK;
    repeat
      dec(FacIdx);
    until(FacIdx<0) OR (FacIdx in fm.fm_pow);
  until FacIdx < 0;
  writeln;

end;

procedure Out_I_th(i: integer);
begin
  if i < 0 then
    write(i:8,' too small');
  if i <= High(FacMulPowGes) then
  begin
    write(i:6,'-th : ');
    Out_MulFac(i,FacMulPowGes[i-1])
  end
  else
    writeln('Too big');
end;

procedure Out_First_N(n: integer);
var
  s,fmt : AnsiString;
  i,tmp : integer;
Begin
  if n<1 then
    EXIT;
  writeln('The first ',n,' Jordan-Polia numbers');
  s := '';
  If n > Length(FacMulPowGes) then
    n := Length(FacMulPowGes);
  dec(n);
  tmp := length(CommatizeUint64(FacMulPowGes[n].fm_num))+1;
  fmt := '%'+IntToStr(tmp)+'s';
  tmp := 72 DIV tmp;
  For i := 0 to n do
  Begin
    s += Format(fmt,[CommatizeUint64(FacMulPowGes[i].fm_num)]);
    if (i+1) mod tmp = 0 then
    Begin
      writeln(s);
      s := '';
    end;
  end;
  if s <>'' then
    writeln(s);
  writeln;
end;

procedure Initfirst;
var
  fac: tnum;
  i,j,idx: integer;
Begin
  fac:= 1;
  j := 1;
  idx := 0;
  For i := 2 to maxFac do
  Begin
    repeat
      inc(j);
      fac *= j;
    until j = i;
    Factorial[idx] := fac;
    inc(idx);
  end;
  Fillchar(LastSearchFor,SizeOf(LastSearchFor),#0);
  LastSearchFor.FM_NUM := 0;
//  dblLimit := 1 shl 53;
  dblLimit := 1 shl 5;
end;

procedure ResetSearch;
Begin
  setlength(FacMulPowGes,0);
end;

procedure GenerateFirst(idx:NativeInt;var res:tFacMulPow);
//generating the first entry with (2!)^n
var
  Fac_mul :tFac_mul;
  facPow,Fac : tnum;
  i,MaxPowOfFac : integer;
begin
  fac := Factorial[idx];
  MaxPowOfFac := trunc(ln(dblLimit)/ln(Fac))+1;
  setlength(res,MaxPowOfFac);

  with Fac_Mul do
  begin
    fm_num := 1;
    fm_pow := [0];
    fm_high_idx := 0;
  end;

  res[0] := Fac_Mul;
  facPow := 1;
  i := 1;
  repeat
    facPow *= Fac;
    if facPow >dblLimit then
      BREAK;
    with Fac_Mul do
    begin
      fm_num := facPow;
      fm_high_pow := i;
    end;
    res[i] := Fac_Mul;
    inc(i);
  until i = MaxPowOfFac;
  setlength(res,i);
end;

procedure DelDoublettes(var FMP:tFacMulPow);
//throw out doublettes,
var
  pNext,pCurrent : tpFac_mul;
  i, len,idx : integer;
begin
  len := 0;
  pCurrent := @FMP[0];
  pNext := pCurrent;
  For i := 0 to High(FMP)-1 do
  begin
    inc(pNext);
    // don't increment pCurrent if equal
    // pCurrent gets or stays the highest Value in n!^high_pow
    if pCurrent^.fm_num = pNext^.fm_num then
    Begin
      idx := pCurrent^.fm_high_idx;
      if idx < pNext^.fm_high_idx then
        pCurrent^  := pNext^
      else
        if idx = pNext^.fm_high_idx then
          if pCurrent^.fm_high_pow < pNext^.fm_high_pow then
            pCurrent^  := pNext^;
    end
    else
    begin
      inc(len);
      inc(pCurrent);
      pCurrent^  := pNext^;
    end;
  end;
  setlength(FMP,len);
end;

procedure QuickSort(var AI: tFacMulPow; ALo, AHi: Int32);
var
  Tmp :tFac_mul;
  Pivot : tnum;
  Lo, Hi : Int32;
begin
  Lo := ALo;
  Hi := AHi;
  Pivot := AI[(Lo + Hi) div 2].fm_num;
  repeat
    while AI[Lo].fm_num < Pivot do
      Inc(Lo);
    while AI[Hi].fm_num > Pivot do
      Dec(Hi);
    if Lo <= Hi then
    begin
      Tmp := AI[Lo];
      AI[Lo] := AI[Hi];
      AI[Hi] := Tmp;
      Inc(Lo);
      Dec(Hi);
    end;
  until Lo > Hi;
  if Hi > ALo then
    QuickSort(AI, ALo, Hi) ;
  if Lo < AHi then
    QuickSort(AI, Lo, AHi) ;
end;

function InsertFacMulPow(var res:tFacMulPow;Facidx:integer):boolean;
var
  Fac,FacPow,NewNum,limit : tnum;
  l_res,l_NewMaxPow,idx,i,j : Integer;
begin
  fac := Factorial[Facidx];
  if fac>dblLimit then
    EXIT(false);

  if length(res)> 0 then
  begin
    l_NewMaxPow := trunc(ln(dblLimit)/ln(Fac))+1;
    l_res := length(res);
    //calc new length, reduces allocation of big memory chunks
    //first original length + length of the new to insert
    j := l_res+l_NewMaxPow;
    //find the maximal needed elements which stay below  dbllimit
    // for every Fac^i
    idx := High(res);
    FacPow := Fac;
    For i := 1 to l_NewMaxPow do
    Begin
      limit := dblLimit DIV FacPow;
      if limit < 1 then
        BREAK;
      //search for the right position
      repeat
        dec(idx);
      until res[idx].fm_num<=limit;
      inc(j,idx);
      FacPow *= fac;
    end;
    j += 2;
    setlength(res,j);

    idx := l_res;
    FacPow := fac;
    For j := 1 to l_NewMaxPow do
    begin
      For i := 0 to l_res do
      begin
        NewNum := res[i].fm_num*FacPow;
        if NewNum>dblLimit then
          Break;
        res[idx]:= res[i];
        with res[idx] do
        Begin
          fm_num := NewNum;
          include(fm_pow,Facidx);
          fm_high_idx := Facidx;
          fm_high_pow := j;
        end;
        inc(idx);
      end;
      FacPow *= fac;
    end;
    setlength(res,idx);
    QuickSort(res,Low(res),High(res));
    DelDoublettes(res);
  end
  else
    GenerateFirst(Facidx,res);
  Exit(true);
end;

var
  i : integer;
BEGIn
  InitFirst;

  repeat
    ResetSearch;
    i := 0;
    repeat
      if Not(InsertFacMulPow(FacMulPowGes,i)) then
        BREAK;
      inc(i);
    until i > High(Factorial);
    //check if MaxIdx is found
    if (Length(FacMulPowGes) > MaxIdx) then
    begin
      if (LastSearchFor.fm_num<> FacMulPowGes[MaxIdx-1].fm_num) then
      Begin
        LastSearchFor := FacMulPowGes[MaxIdx-1];
        //the next factorial is to big, so search is done
        if LastSearchFor.fm_num < Factorial[i] then
          break;
      end
      else
        Break;
    end;
    if dblLimit> HIGH(tNUm) DIV 256 then
      BREAK;
    dblLimit *= 256;
  until false;

  write('Found ',length(FacMulPowGes),' Jordan-Polia numbers ');
  writeln('up to ',CommatizeUint64(dblLimit));
  writeln;

  Out_First_N(50);

  write('The last < 1E8 ');
  for i := 0 to High(FacMulPowGes) do
    if FacMulPowGes[i].fm_num > 1E8 then
    begin
      Out_MulFac(i,FacMulPowGes[i-1]);
      BREAK;
    end;
  writeln;

  Out_I_th(1);
  Out_I_th(100);
  Out_I_th(800);
  Out_I_th(1050);
  Out_I_th(1800);
  Out_I_th(2800);
  Out_I_th(3800);
END.
