program DNA_Base_Count;
{$IFDEF FPC}
  {$MODE DELPHI}//String = AnsiString
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
const
    dna =
        'CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG' +
        'CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG' +
        'AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT' +
        'GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT' +
        'CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG' +
        'TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA' +
        'TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT' +
        'CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG' +
        'TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC' +
        'GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT';
var
  CntIdx : array of NativeUint;
  DNABases : String;
  SumBaseTotal : NativeInt;

procedure OutFormatBase(var DNA: String;colWidth:NativeInt);
var
  j: NativeInt;
Begin
  j := 0;
  Writeln(' DNA base sequence');
  While j<Length(DNA) do
  Begin
    writeln(j:5,copy(DNA,j+1,colWidth):colWidth+2);
    inc(j,colWidth);
  end;
  writeln;
end;

procedure Cnt(const DNA: String);
var
  i,p :NativeInt;
Begin
  SetLength(CntIdx,Length(DNABases));
  i := 1;
  while i <= Length(DNA) do
  Begin
    p := Pos(DNA[i],DNABases);
    //found new base so extend list
    if p = 0 then
    Begin
      DNABases := DNABases+DNA[i];
      p := length(DNABases);
      Setlength(CntIdx,p+1);
    end;
    inc(CntIdx[p]);
    inc(i);
  end;

  Writeln('Base     Count');
  SumBaseTotal := 0;
  For i := 1 to Length(DNABases) do
  Begin
    p := CntIdx[i];
    inc(SumBaseTotal,p);
    writeln(DNABases[i]:4,p:10);
  end;
  Writeln('Total base count ',SumBaseTotal);
  writeln;
end;

var
  TestDNA: String;
Begin
  DNABases :='ACGT';// predefined
  TestDNA := DNA;
  OutFormatBase(TestDNA,50);
  Cnt(TestDNA);
end.
