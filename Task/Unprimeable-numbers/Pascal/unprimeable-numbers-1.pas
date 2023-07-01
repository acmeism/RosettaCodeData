program unprimable;
{$IFDEF FPC}{$Mode Delphi}{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}

const
  base = 10;

type
  TNumVal = array[0..base-1] of NativeUint;
  TConvNum = record
               NumRest : TNumVal;
               LowDgt,
               MaxIdx : NativeUint;
             end;

var //global
  PotBase,
  EndDgtFound : TNumVal;
  TotalCnt,
  EndDgtCnt :NativeUint;

procedure Init;
var
  i,val : NativeUint;
Begin
  val := 1;
  For i := low(TNumVal) to High(TNumVal) do
  Begin
    EndDgtFound[i] :=0;
    PotBase[i] := val;
    val := val * Base;
  end;
  TotalCnt := 0;
  EndDgtCnt := 0;
end;

Procedure ConvertNum(n: NativeUint;var NConv:TConvNum);
//extract digit position replace by "0" to get NumRest
// 173 -> 170 -> 103 -> 073
var
  i, dgt,n_red,n_mod: NativeUint;
begin
  i := 0;
  n_red := n;
  with NConv do
  Begin
    repeat
      n_mod := n_red DIV Base;
      dgt := n_red-Base*n_mod;
      n_red := n_mod;
      IF i = 0 then
        LowDgt := dgt;
      NumRest[i]:= n-dgt*PotBase[i];
      inc(i);
    until (i > High(TNumVal)) OR (n<PotBase[i]);
    MaxIdx := i-1;
  end;
end;

procedure CheckOutPut(n: NativeUint);
Begin
  IF TotalCnt > 600 then
    EXIT;
  IF TotalCnt <= 35 then
    write(n,' ');
  IF TotalCnt = 600 then
  Begin
    writeln;
    writeln;
    writeln('the 600.th unprimable number: ',n);
  end;
end;

function isPrime(n : NativeUint):boolean;inline;
var
  p : NativeUint;
Begin
  result := (N=2) OR (N=3);
  IF result then
    EXIT;
  //now result = false
  IF (n<2) OR (NOT(ODD(n))) or (n mod 3= 0) then
    EXIT;
  p := 5;
  while p*p <= n do
  Begin
    if n mod p = 0 then
      Exit;
    inc(p,2);
    if n mod p = 0 then
      Exit;
    inc(p,4);
  end;
  result := true;
end;

procedure InsertFound(LowDgt,n:NativeUInt);
Begin
  inc(TotalCnt);
  IF EndDgtFound[LowDgt] = 0 then
  Begin
    EndDgtFound[LowDgt] := n;
    inc(EndDgtCnt);
  end;
end;

function CheckUnprimable(n:NativeInt):boolean;
var
  ConvNum : TConvNum;
  val,dgt,i,dtfac: NativeUint;
Begin
  ConvertNum(n,ConvNum);
  result := false;
  //lowest digit
  with ConvNum do
  Begin
    val := NumRest[0];
    For dgt := 0 to Base-1 do
      IF isPrime(val+dgt) then
        EXIT;
    dgt := LowDgt;

    result := true;
    i := MaxIdx;
    IF NumRest[i] >= Base then
    Begin
//****Only for base=10 if even or divisible by 5***
      IF Not(ODD(dgt)) OR (dgt=5) then
      Begin
        InsertFound(dgt,n);
        EXIT;
      end;
    end;

    result := false;
    For i := MaxIdx downto 1 do
    Begin
      dtfac := PotBase[i];
      val := NumRest[i];
      For dgt := 0 to Base-1 do
      Begin
        IF isPrime(val) then
          EXIT;
        inc(val,dtfac);
      end;
    end;
    InsertFound(LowDgt,n);
    result := true;
  end;
end;

function CheckUnprimableReduced(n:NativeInt):boolean;
//lowest digit already tested before
var
  ConvNum : TConvNum;
  val,dgt,i,dtfac: NativeUint;
Begin
  ConvertNum(n,ConvNum);
  result := true;
  with ConvNum do
  Begin
    i := MaxIdx;
    IF NumRest[i] >= Base then
    Begin
      dgt := LowDgt;
      IF Not(ODD(dgt)) OR (dgt=5) then
      Begin
        InsertFound(dgt,n);
        EXIT;
      end;
    end;

    result := false;
    For i := i downto 1 do
    Begin
      dtfac := PotBase[i];
      val := NumRest[i];
      For dgt := 0 to Base-1 do
      Begin
        IF isPrime(val) then
          EXIT;
        inc(val,dtfac);
      end;
    end;
    InsertFound(LowDgt,n);
    result := true;
  end;
end;

var
  n,i : NativeUint;
Begin
  init;
  n := Base;
  repeat
    If CheckUnprimable(n) then
    Begin
      CheckOutPut(n);
      For i := 1 to Base-1 do
      Begin
        IF CheckUnprimableReduced(n+i) then
          CheckOutPut(n+i);
      end;
    end;
    inc(n,Base);
  until EndDgtCnt = Base;
  writeln;
  For i := 0 to Base-1 do
    Writeln ('lowest digit ',i:2,' found first ',EndDgtFound[i]:7);
  writeln;
  writeln('There are ',TotalCnt,' unprimable numbers upto ',n);
  {$IFNDEF UNIX}readln;{$ENDIF}
end.
