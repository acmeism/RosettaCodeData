program base_count;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Generics.Collections,
  System.Console;

const
  DNA = 'CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG' +
    'CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG' +
    'AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT' +
    'GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT' +
    'CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG' +
    'TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA' +
    'TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT' +
    'CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG' +
    'TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC' +
    'GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT';

procedure Println(code: ansistring);
var
  c: ansichar;
begin
  console.ForegroundColor := TConsoleColor.Black;
  for c in code do
  begin
    case c of
      'A':
        console.BackgroundColor := TConsoleColor.Red;
      'C':
        console.BackgroundColor := TConsoleColor.Blue;
      'T':
        console.BackgroundColor := TConsoleColor.Green;
      'G':
        console.BackgroundColor := TConsoleColor.Yellow;
    else
      console.BackgroundColor := TConsoleColor.Black;
    end;
    console.Write(c);
  end;
  console.ForegroundColor := TConsoleColor.White;
  console.BackgroundColor := TConsoleColor.Black;
  console.WriteLine;
end;

begin
  console.WriteLine('SEQUENCE:');
  var le := Length(DNA);
  var index := 0;
  while index < le do
  begin
    Write(index: 5, ': ');
    Println(dna.Substring(index, 50));

    inc(index, 50);
  end;

  var baseMap := TDictionary<byte, integer>.Create;

  for var i := 1 to le do
  begin
    var key := ord(dna[i]);
    if baseMap.ContainsKey(key) then
      baseMap[key] := baseMap[key] + 1
    else
      baseMap.Add(key, 1);
  end;

  var bases: TArray<byte>;
  for var k in baseMap.Keys do
  begin
    SetLength(bases, Length(bases) + 1);
    bases[High(bases)] := k;
  end;
  TArray.Sort<Byte>(bases);

  console.WriteLine(#10'BASE COUNT:');

  for var base in bases do
    console.WriteLine('    {0}: {1}', [ansichar(base), baseMap[base]]);

  console.WriteLine('    ------');
  console.WriteLine('    S: {0}', [le]);
  console.WriteLine('    ======');

  readln;
end.
