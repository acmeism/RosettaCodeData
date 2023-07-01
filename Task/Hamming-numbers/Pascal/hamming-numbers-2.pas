{$OPTIMIZATION LEVEL4}
program Hammings(output);

{$mode objfpc}
uses Math, SysUtils;

const
  lb22 : Double = 1.0; (* log base 2 of 2 *)
  lb23 : Double = 1.58496250072115618147; (* log base 2 of 3 *)
  lb25 : Double = 2.32192809488736234781; (* log base 2 of 5 *)

type
  TLogRep = record
    lr : Double;
    x2, x3, x5 : Word;
  end;

const oneLogRep : TLogRep = (lr:0.0; x2:0; x3:0; x5:0);

function LogRepMult2(lr : TLogRep) : TLogRep;
begin
  Result := lr;
  Result.lr := lr.lr + lb22;
  Result.x2 := lr.x2 + 1
end;

function LogRepMult3(lr : TLogRep) : TLogRep;
begin
  Result := lr;
  Result.lr := lr.lr + lb23;
  Result.x3 := lr.x3 + 1
end;

function LogRepMult5(lr : TLogRep) : TLogRep;
begin
  Result := lr;
  Result.lr := lr.lr + lb25;
  Result.x5 := lr.x5 + 1
end;

function LogRep2QWord(lr : TLogRep) : QWord;
function xpnd(x : Word; m : QWord) : QWord;
var mlt : QWord;
begin
  mlt := m;
  Result := 1;
  while x > 0 do
  begin
    if x and 1 > 0 then Result := Result * mlt;
    mlt := mlt * mlt; x := x shr 1
  end
end;
begin
  Result := xpnd(lr.x2, 2) * xpnd(lr.x3, 3) * xpnd(lr.x5, 5)
end;

function LogRep2String(lr : TLogRep) : AnsiString;
type TBI = array of LongWord;
     TDigitStr = String[1];
function mul2(bi : TBI) : TBI;
var cry : QWord;
    i : Integer;
begin
  cry := 0;
  for i := 0 to High(bi) do
  begin
    cry := (QWord(bi[i]) shl 1) + cry; bi[i] := cry; cry := cry shr 32
  end;
  if cry <> 0 then
  begin
    SetLength(bi, Length(bi) + 1); bi[High(bi)] := cry
  end;
  Result := bi
end;
function add(bia : TBI; bib : TBI) : TBI;
var cry : QWord;
    i : Integer;
begin
  cry := 0;
  for i := 0 to High(bia) do
  begin
    cry := QWord(bia[i]) + QWord(bib[i]) + cry;
    bia[i] := cry; cry := cry shr 32
  end;
  if cry <> 0 then
  begin
    SetLength(bia, Length(bia) + 1); bia[High(bia)] := cry
  end;
  Result := bia
end;
function div10(bi : TBI) : TDigitStr;
var brw : QWord;
    i : Integer;
begin
  brw := 0;
  for i := High(bi) downto 0 do
  begin
    brw := (brw shl 32) + QWord(bi[i]);
    bi[i] := brw div 10; brw := brw - QWord(bi[i]) * 10
  end;
  Result := IntToStr(brw)
end;
var v : Word;
    xpnd, xpndt : TBI;
begin
  Result := '';
  SetLength(xpnd, 1); xpnd[0] := 1;
  for v := lr.x2 downto 1 do xpnd := mul2(xpnd);
  for v := lr.x3 downto 1 do
  begin
    xpndt := Copy(xpnd, 0, Length(xpnd));
    xpnd := mul2(xpnd); xpnd := add(xpnd, xpndt)
  end;
  for v := lr.x5 downto 1 do
  begin
    xpndt := Copy(xpnd, 0, Length(xpnd)); xpnd := mul2(xpnd);
    xpnd := mul2(xpnd); xpnd := add(xpnd, xpndt)
  end;
  while Length(xpnd) > 0 do
  begin
    Result := div10(xpnd) + Result;
    if xpnd[High(xpnd)] <= 0 then SetLength(xpnd, Length(xpnd) - 1)
  end
end;

type
  TLogReps = array of TLogRep;
  THammings = class
  private
    FCurrent : TLogRep;
    FBA, FMA : TLogReps;
    Fnxt2, Fnxt3, Fnxt5, Fmrg35 : TLogRep;
    FBb, FBe, FMb, FMe : Integer;
  public
    constructor Create;
    function GetEnumerator : THammings;
    function MoveNext : Boolean;
    property Current : TLogRep read FCurrent;
  end;

constructor THammings.Create;
begin
  inherited Create;
  FCurrent := oneLogRep; FCurrent.lr := -1.0;
  SetLength(FBA, 4); SetLength(FMA, 4);
  Fnxt5 := LogRepMult5(oneLogRep);
  Fmrg35 := LogRepMult3(oneLogRep);
  Fnxt3 := LogRepMult3(Fmrg35);
  Fnxt2 := LogRepMult2(oneLogRep);
  FBb := 0; FBe := 0; FMb := 0; FMe := 0
end;

function THammings.GetEnumerator : THammings;
begin
  Result := Self
end;

function THammings.MoveNext : Boolean;
var blen, mlen, i, j : Integer;
begin
  if FCurrent.lr < 0.0 then FCurrent.lr := 0.0 else
  begin
    blen := Length(FBA);
    if FBb >= blen shr 1 then
    begin
      i := 0;
      for j := FBb to FBe - 1 do
      begin
        FBA[i] := FBA[j]; Inc(i)
      end;
      FBe := FBe - FBb; FBb := 0
    end;
    if FBe >= blen then SetLength(FBA, blen shl 1);
    if Fnxt2.lr < Fmrg35.lr then
    begin
      FCurrent := Fnxt2; FBA[FBe] := FCurrent;
      Fnxt2 := LogRepMult2(FBA[FBb]); Inc(FBb)
    end
    else
    begin
      mlen := Length(FMA);
      if FMb >= mlen shr 1 then
      begin
        i := 0;
        for j := FMb to FMe - 1 do
        begin
          FMA[i] := FMA[j]; Inc(i)
        end;
        FMe := FMe - FMb; FMb := 0
      end;
      if FMe >= mlen then SetLength(FMA, mlen shl 1);
      if Fmrg35.lr < Fnxt5.lr then
      begin
        FCurrent := Fmrg35; FMA[FMe] := FCurrent;
        Fnxt3 := LogRepMult3(FMA[FMb]); Inc(FMb)
      end
      else
      begin
        FCurrent := Fnxt5; FMA[FMe] := FCurrent;
        Fnxt5 := LogRepMult5(Fnxt5)
      end;
      if Fnxt3.lr < Fnxt5.lr then Fmrg35 := Fnxt3 else Fmrg35 := Fnxt5;
      FBA[FBe] := FCurrent; Inc(FMe)
    end;
    Inc(FBe)
  end;
  Result := True
end;

var elpsd : QWord;
    count : Integer;
    h : TLogRep;

begin
  write('The first 20 Hamming numbers are: ');
  count := 0;
  for h in THammings.Create do
  begin
    Inc(count);
    if count > 20 then break;
    write(' ', LogRep2QWord(h));
  end;
  writeln('.');
  count := 1;
  for h in THammings.Create do
  begin
    Inc(count);
    if count > 1691 then break;
  end;
  writeln('The 1691st Hamming number is ', LogRep2QWord(h), '.');
  elpsd := GetTickCount64;
  count := 1;
  for h in THammings.Create do
  begin
    Inc(count);
    if count > 1000000 then break;
  end;
  elpsd := GetTickCount64 - elpsd;
  writeln('The millionth Hamming number is approximately ', 2.0**h.lr, '.');
  write('The millionth Hamming triplet is ');
  writeln('2^', h.x2, ' * 3^', h.x3, ' * 5^', h.x5, '.');
  writeln('The millionth Hamming number is ', LogRep2String(h), '.');
  writeln('This last took ', elpsd, ' milliseconds.')
end.
