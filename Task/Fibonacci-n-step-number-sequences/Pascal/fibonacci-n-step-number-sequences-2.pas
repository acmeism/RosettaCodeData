program FibbonacciN (output);
{$IFNDEF FPC}
   {$APPTYPE CONSOLE}
{$ENDIF}
const
  MAX_Nacci = 10;

  No_of_examples = 11;// max 90; (golden ratio)^No < 2^64
  Name: array[2..11] of string = ('Fibonacci:  ',
                                  'Tribonacci: ',
                                  'Tetranacci: ',
                                  'Pentanacci: ',
                                  'Hexanacci:  ',
                                  'Heptanacci: ',
                                  'Octonacci:  ',
                                  'Nonanacci:  ',
                                  'Decanacci:  ',
                                  'Lucas:      '
                                 );

type
  tfibIdx = 0..MAX_Nacci;
  tNacVal = Uint64;// longWord
  tNacci = record
             ncSum      : tNacVal;
             ncLastFib  : array[tFibIdx] of tNacVal;
             ncNextIdx  : array[tFibIdx] of tFibIdx;
             ncIdx      : tFibIdx;
             ncValue    : tFibIdx;
           end;


function CreateNacci(n: tFibIdx): TNacci;
var
  i : tFibIdx;
  sum :tNacVal;
begin
  //With result do
  with CreateNacci do
  begin
     ncLastFib[0] := 1;
     ncLastFib[1] := 1;
     For i := 2 to n-1 do
       ncLastFib[i] := ncLastFib[i-1] * 2;

     Sum := 0;
     For i := 0 to n-1 do
       sum := sum +ncLastFib[i];
     ncSum := Sum;
     //No need to do a compare
     //inc(idx);
     //if idx>= n then
     //  idx := 0;
     //idx := nextIdx[idx]
     For i := 0 to n-2 do
       ncNextIdx[i] := i+1;
     ncNextIdx[n-1] := 0;
     ncIdx   := 0;
  end;
end;

function LehmerCreate:TNacci;
begin
  with LehmerCreate do
  begin
     ncLastFib[0] := 2;
     ncLastFib[1] := 1;
     ncSum := 3;
     ncNextIdx[0] := 1;
     ncNextIdx[1] := 0;
     ncIdx   := 0;
  end;
end;

function NextNacci(var Nacci:tNacci):tNacVal;
var
  NewSum :tNacVal;
begin
  with Nacci do
  begin
    NewSum := 2*ncSum- ncLastFib[ncIdx];
    ncLastFib[ncIdx] := ncSum;
    ncIdx := ncNextIdx[ncIdx];
    NextNacci := ncSum;
    ncSum := NewSum;
  end;
end;

var
  Nacci : tNacci;
  j, k: integer;

BEGIN
  for j := 2 to 10 do
  begin
    Nacci := CreateNacci(j);
    write (Name[j]);
    For k := 0 to j-1 do
      write(Nacci.ncLastFib[k],' ');
    For k := j to No_of_examples-1 do
      write(NextNacci(Nacci),' ');
    writeln;
  end;

  write (Name[11]);
  j := 2;
  Nacci := LehmerCreate;
  For k := 0 to j-1 do
    write(Nacci.ncLastFib[k],' ');
  For k := j to No_of_examples-1 do
    write(NextNacci(Nacci),' ');
  writeln;
END.
