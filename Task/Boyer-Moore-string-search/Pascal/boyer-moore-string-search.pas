program BMTest;
{$mode objfpc}{$h+}
{$modeswitch functionreferences}
{$modeswitch anonymousfunctions}
uses
  SysUtils, Math;

type
  TSearchFun = reference to function(const s: rawbytestring): specialize TArray<SizeInt>;

{ returns a function that performs a case-sensitive search for all occurrences(1-based)
  of the specified pattern using the Boyer-Moore algorithm with Galil optimization }
function BmgCreate(const aPattern: rawbytestring): TSearchFun;
var
  BcTable: array[Byte] of Integer; //bad character shifts
  p: PByte absolute aPattern;
  procedure FillBcTable;
  var
    I: Integer;
  begin
    FillDWord(BcTable, Length(BcTable), DWord(Length(aPattern)));
    for I := 0 to Length(aPattern) - 2 do
      BcTable[p[I]] := Pred(Length(aPattern) - I);
  end;
var
  GsTable: array of Integer = nil; //good suffix shifts
  procedure MakeGsTable;
    function IsPrefix(aPos: Integer): Boolean;
    var
      I, SuffixLen: Integer;
    begin
      SuffixLen := Length(aPattern) - aPos;
      for I := 0 to Pred(SuffixLen) do
        if (p[I] <> p[aPos + I]) then exit(False);
      Result := True;
    end;
    function GetSuffixLen(aPos: Integer): Integer;
    begin
      Result := 0;
      while(Result < aPos)and(p[aPos - Result] = p[Pred(Length(aPattern) - Result)])do
        Inc(Result);
    end;
  var
    I, LastPrefix, SuffixLen: Integer;
  begin
    SetLength(GsTable, Length(aPattern));
    LastPrefix := Pred(Length(aPattern));
    for I := Pred(Length(aPattern)) downto 0 do begin
      if IsPrefix(Succ(I)) then
        LastPrefix := Succ(I);
      GsTable[I] := LastPrefix + Length(aPattern) - Succ(I);
    end;
    for I := 0 to Length(aPattern) - 2 do begin
      SuffixLen := GetSuffixLen(I);
      if p[I - SuffixLen] <> p[Pred(Length(aPattern) - SuffixLen)] then
        GsTable[Pred(Length(aPattern) - SuffixLen)] := Pred(Length(aPattern) + SuffixLen - I);
    end;
  end;
var
  Needle: rawbytestring;
begin
  if aPattern <> '' then begin
    Needle := aPattern;
    FillBcTable;
    MakeGsTable;
  end else
    Needle := '';
{ returns an empty array if there are no matches or the pattern is empty }
  Result := function(const aHaystack: rawbytestring): specialize TArray<SizeInt>
  var
    pNeedle: PByte absolute Needle;
    pHaystack: PByte absolute aHaystack;
    I, J, NeedleLast, OutPos, OldPfxEnd: SizeInt;
  const
    OutInitLen = 4;
  begin
    Result := nil;
    if (Needle = '') or (Length(aHaystack) < Length(Needle)) then exit;
    SetLength(Result, OutInitLen);
    OutPos := 0;
    NeedleLast := Pred(Length(Needle));
    I := NeedleLast;
    OldPfxEnd := 0;
    while I < Length(aHaystack) do begin
      J := NeedleLast;
      while (J >= OldPfxEnd) and (pNeedle[J] = pHaystack[I]) do begin
        Dec(J); Dec(I);
      end;
      if J < OldPfxEnd then begin
        if OutPos = Length(Result) then SetLength(Result, OutPos * 2);
        Result[OutPos] := I - OldPfxEnd + 2;
        Inc(OutPos);
        Inc(I, Succ(GsTable[0] - OldPfxEnd));
        OldPfxEnd := Length(Needle)*2 - GsTable[0];
      end else begin
        Inc(I, Max(BcTable[pHaystack[I]], GsTable[J]));
        OldPfxEnd := 0;
      end;
    end;
    SetLength(Result, OutPos);
  end;
end;

procedure WriteArray(const a: array of SizeInt);
var
  I: SizeInt;
begin
  Write('[');
  for I := 0 to High(a) do
    if I < High(a) then Write(a[I], ', ')
    else Write(a[I]);
  WriteLn(']');
end;

const
  Text1 = 'Nearby farms grew a half acre of alfalfa on the dairy''s behalf, with bales of all that alfalfa exchanged for milk';
  Text2 = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
  Text3 = 'CAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGT';
  Text4 = 'AGGTGTGGAAACAAGCACCTAGATGTGCTGAACCCGGGGCACACGTTCAGTCAGCGACTC';
var
  BmgSearch: TSearchFun;
begin
  WriteArray(BmgCreate('alfalfa')(Text1));
  WriteArray(BmgCreate('aaaaaaaaaaaaaaaaaaaa')(Text2));
  BmgSearch := BmgCreate('CAGTCAG');
  WriteArray(BmgSearch(Text3));
  WriteArray(BmgSearch(Text4));
end.
