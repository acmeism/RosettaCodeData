program MissPerm;
{$MODE DELPHI} //for result

const
  maxcol = 4;
type
  tmissPerm = 1..23;
  tcol = 1..maxcol;
  tResString = String[maxcol];
const
  Given_Permutations : array [tmissPerm] of tResString =
     ('ABCD', 'CABD', 'ACDB', 'DACB', 'BCDA', 'ACBD',
      'ADCB', 'CDAB', 'DABC', 'BCAD', 'CADB', 'CDBA',
      'CBAD', 'ABDC', 'ADBC', 'BDCA', 'DCBA', 'BACD',
      'BADC', 'BDAC', 'CBDA', 'DBCA', 'DCAB');
  chOfs =  Ord('A')-1;
var
  SumElemCol: array[tcol,tcol] of NativeInt;
function fib(n: NativeUint): NativeUint;
var
  i : NativeUint;
Begin
  result := 1;
  For i := 2 to n do
    result:= result*i;
end;

function CountOccurences: tresString;
//count the number of every letter in every column
//should be (colmax-1)! => 6
//the missing should count (colmax-1)! -1 => 5
var
  fibN_1 : NativeUint;
  row, col: NativeInt;
Begin
  For row := low(tmissPerm) to High(tmissPerm) do
    For col := low(tcol) to High(tcol) do
      inc(SumElemCol[col,ORD(Given_Permutations[row,col])-chOfs]);

  //search the missing
  fibN_1 := fib(maxcol-1)-1;
  setlength(result,maxcol);
  For col := low(tcol) to High(tcol) do
    For row := low(tcol) to High(tcol) do
      IF SumElemCol[col,row]=fibN_1 then
        result[col]:= ansichar(row+chOfs);
end;

function CheckXOR: tresString;
var
  row,col: NativeUint;
Begin
  setlength(result,maxcol);
  fillchar(result[1],maxcol,#0);
  For row := low(tmissPerm) to High(tmissPerm) do
    For col := low(tcol) to High(tcol) do
      result[col] := ansichar(ord(result[col]) XOR ord(Given_Permutations[row,col]));
end;

Begin
  writeln(CountOccurences,' is missing');
  writeln(CheckXOR,' is missing');
end.
