program BaseInDNA;
{$IFDEF FPC}
  {$mode Delphi}  {$Optimization ON,All}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils,classes;
type
  tmyString = AnsiString;//[255];
  tpMyString = ^tmyString;
  tOvrLapMat = array of array of Int32;
  tNextDNA = array of Int32;
  tpNextDNA = pInt32;
const
  convDgtBase :array['1'..'5'] of char = ('A','C','G','T','U');

  Test1 : array[0..4] of tmyString = ('TA','AAG','TA','GAA','TA');
  Test2 : array[0..3] of tmyString = ('CATTAGGG', 'ATTAG', 'GGG', 'TA');
  Test3 : array[0..2] of tmyString = ('AAGAUGGA', 'GGAGCGCAUC', 'AUCGCAAUAAGGA');
  Test4 : array[0..12] of tmyString =
('ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT',
'GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT',
'CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA',
'TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC',
'AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT',
'GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC',
'CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT',
'TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC',
'CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC',
'GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT',
'TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC',
'CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA',
'TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA');
var
  sl_DNA : TStringList;
  OverlapMat : tOvrLapMat;
  SolDNA : tNextDNA;
  pNextDNA : tpNextDNA;
  DNA_Count,MAX,LastMax : Int32;

function ConvertACGT_1234(const s:AnsiString):AnsiString;
const
  conv :array['A'..'U'] of char = ('1',#0,'2',#0,#0,#0,'3',#0,#0,
                                   #0,#0,#0,#0,#0,#0,#0,#0,#0,
                                   #0,'4','5');
var
  pC: pChar;
  i : NativeInt;
begin
  i := Length(s);
  setlength(result,i);
  pC := @result[1];
  dec(i);
  while i >= 0 do
  Begin
    pC[i] := conv[s[i+1]];
    dec(i);
  end;
end;

function Convert1234_ACGTU(const s:AnsiString):AnsiString;
var
  pC: pChar;
  i : NativeInt;
begin
  i := Length(s);
  setlength(result,i);
  pC := @result[1];
  dec(i);
  while i >= 0 do
  Begin
    pC[i] := convDgtBase[s[i+1]];
    dec(i);
  end;
end;

procedure Check_Base_Count(const s: ANsiString);
var
  bc : ANsiString;
  BaseCnt : array[0..4] of UInt32;
  pC: pChar;
  i : NativeInt;
Begin
  writeln('Total length : ',Length(s));
  bc := ConvertACGT_1234(s);
  FillChar(BaseCnt,SizeOf(BaseCnt),#0);
  pC := @bc[1];
  for i := length(bc)-1 downto 0 do
    inc(BaseCnt[Ord(pC[i])-Ord('1')]);
  For i := 0 to 4 do
    write(convDgtBase[chr(i+49)],' : ',BaseCnt[i]:3,'  ');
  writeln;
end;

procedure extract_double(var sl : TStringList);
var
  i,j : NativeInt;
begin
  sl.sort;
  for i := sl.count-2 downto 0 do
    if sl[i] = sl[i+1] then
      sl.delete(i+1);

  i := sl.count-1;
  repeat
    For j := i-1 Downto 0 do
    Begin
      if (Pos(sl[j],sl[i]) >0) then
      Begin
        sl.delete(j);
        i := sl.count;
        BREAK;
      end
      else
        if (Pos(sl[i],sl[j]) >0) then
        Begin
          sl.delete(i);
        i := sl.count;
        BREAK;
        end;
    end;
    dec(i);
  until i < 1;
end;

procedure InsertSL(var sl : TStringList;pS :tpMyString;cnt:NativeInt);
Begin
  sl.clear;
  while cnt > 0 do
  Begin
    sl.Append(pS^);
    inc(pS);
    dec(cnt);
  end;
  extract_double(sl);
  sl.sort;
end;

function Check_Head_Tail(const s1,s2: AnsiString):NativeInt;
var
  cH : AnsiChar;
  i,j,k : NativeInt;
Begin
  result := 0;
  j := length(s1);
  cH := s2[1];
  repeat
    if s1[j]= cH then
    Begin
      i:= 1;
      k := j;
      while (s1[k] = s2[i]) AND (k <= length(s1)) do
      begin
        inc(i);
        inc(k);
      end;
      if k > length(s1) then
        result := length(s1)-j+1;
    end;
    dec(j);
  until j <1;
end;

function CreateOvrLapMat(const sl_DNA:TStringList):tOvrLapMat;
var
  col,row,DNAlen : NativeInt;
begin
  DNAlen := sl_DNA.Count;
  setlength(result,DNAlen,DNAlen);

  dec(DNAlen);
  For row := DNAlen downto 0 do
    For col := DNAlen downto 0 do
      if row<>col then
        result[row,col] := Check_Head_Tail(sl_DNA[row],sl_DNA[col]);
{//output of matrix
  For row := 0 to DNAlen do
  Begin
    For col := 0 to DNAlen do
      write(OverlapMat[row,col]:3);
    writeln;
  end;
}

end;

procedure SetQueen(Row,sum,lastIdx:NativeInt);
var
  i,NextIdx,dSum : nativeInt;
begin
  IF row <= DNA_Count-1 then
  begin
    For i := row to DNA_Count-1 do
    begin
      NextIdx := pNextDNA[i];pNextDNA[i] := pNextDNA[Row];pNextDNA[Row] := NextIdx;
      dSum :=OverlapMat[lastidx,NextIdx];
      sum += dSum;
        SetQueen(Row+1,sum,NextIdx);
      sum -= dSum;
      pNextDNA[Row] := pNextDNA[i];pNextDNA[i] := NextIdx;
    end;
  end
  else
  begin
    //solution found could be modified MAX<=sum for more solutions of same length
    If MAX<sum then
    Begin
      MAX := sum;
      // remember the way
      for i := DNA_Count-1 downto 0 do
        SolDNA[i+1] := pNextDNA[i];
    end;
  end;
end;

procedure Find;
var
  col,row,i : NativeInt;
  NextDNA : tNextDNA;
  Combined : AnsiString;
Begin
  DNA_Count := sl_DNA.count;

  IF DNA_Count = 1 then
    Combined := sl_DNA[0]
  else
  Begin
    setlength(SolDNA,DNA_count);
    dec(DNA_Count);
    setlength(NextDNA,DNA_count);

    //Tail-Head-Matrix
    OverlapMat := CreateOvrLapMat(sl_DNA);

    MAX := 0;
    LastMax := 0;
    pNextDNA := @NextDNA[0];
    //start with base_sequence[row]
    for row := 0 to DNA_count do
    begin
      i := 0;
      For col := 0 to DNA_count do
        if row<>col then
        begin
          pNextDNA[i] := col;
          inc(i);
        end;

        SetQueen(0,0,row);

       If LastMax< MAX then
       begin
         SolDNA[0]:= row;
         LastMax := MAX;
      end;
    end;
    Combined := '';
    for col := 0 to DNA_Count-1 do
    Begin
      write(SolDNA[col]+1,'->');
      row := length(sl_DNA[SolDNA[col]]);
      Combined += copy(sl_DNA[SolDNA[col]],1,row-OverlapMat[SolDNA[col],SolDNA[col+1]]);
    end;
    writeln(SolDNA[DNA_Count]+1);
    Combined += sl_DNA[SolDNA[DNA_Count]];

    LastMax := 0;
    for col := 0 to DNA_Count do
      inc(LastMax,Length(sl_DNA[col]));
    IF LastMax-MAX <> length(combined) then
      writeln(LastMax,'-',Max,' = ',LastMax-MAX,' ?=? ',length(combined));
  end;
  writeln(combined);
  Check_Base_Count(combined);
  writeln;
end;


BEGIN
  sl_DNA := TStringList.create;
  InsertSL(sl_DNA,@Test1[0],High(Test1)+1);
  find;
  InsertSL(sl_DNA,@Test2[0],High(Test2)+1);
  find;
  InsertSL(sl_DNA,@Test3[0],High(Test3)+1);
  find;
  InsertSL(sl_DNA,@Test4[0],High(Test4)+1);
  find;
END.
