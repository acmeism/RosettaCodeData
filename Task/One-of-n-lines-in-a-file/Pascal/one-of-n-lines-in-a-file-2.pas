Program OneOfNLines(InPut,Output);
{$h+} //use Ansistring
{type
  NativeInt = LongInt;}

function one_of_n(n: NativeInt): NativeInt;
  var
    ch,i: LongInt;// doubles speed of random using 64-Bit :-(
  begin
    ch := 1;
    for i := 2 to n do
      if random(i) = 0 then
        ch := i;
    one_of_n := ch;
  end;

function ChooseRNDLine(          fileNm : string;
                       var LnChsn,LnCnt :NativeInt):string;
var
  choosen,
  n : NativeInt;
  f : textFile;
  actRow,
  chsnRow: string;
  buf : array[0..4095] of char;// speed things up
begin
  n:= 0;
  choosen := n;
  chsnRow := '';

  Assign(f,fileNm);
  {$I-}
  Reset(f);
  {$I+}
  IF IoResult <> 0 then
     close(f)
  else
  Begin
    SetTextBuf(f,Buf[0]);

    while Not(EOF(f)) do
    Begin
      readln(f,actRow);
      inc(n);
      IF Random(n)= 0 then
      begin
        chsnRow:= actRow;
        choosen := n;
      end;
    end;
    close(f);
  end;

  LnChsn := choosen;
  LnCnt := n;
  ChooseRNDLine := chsnRow;
end;

const
  cFn = 'OneOfNLines.s';// compiled with -al assembler output
  num_reps = 1000000;
  num_lines_in_file = 10;

var
  Ln    : String;
  LnChsn,
  LnCnt,
  i     : NativeInt;
  cntLns: array[1..num_lines_in_file] of NativeUint;
begin
  randomize;
  Ln := ChooseRNDLine(cFn,LnChsn,LnCnt);
  writeln('choosen ', LnChsn,' out of ',LnCnt );
  writeln(Ln);writeln;

  FillChar(cntLns,SizeOf(cntLns),#0);
  for i := 1 to num_reps do
    inc(cntLns[one_of_n(num_lines_in_file)]);
  for i := 1 to num_lines_in_file do
    writeln('Number of times line ', i, ' was selected: ', cntLns[i]);

  LnCnt := 0;
  For i := Low(cntLns) to High(cntLns) do
    inc(LnCnt,cntLns[i]);
  writeln('Total number selected: ', LnCnt);
end.
