{This code normally resides in a library, it is provided here for clarity}

type T2DMatrix = class(TObject)
 private
  FDoubleArray: array of double;
  FRows,FColumns: integer;
  procedure Put(Row,Col: integer; Item: double);
  function Get(Row,Col: integer): double;
 protected
 public
  constructor Create(Row,Col: integer);
  property Rows: integer read FRows;
  property Columns: integer read FColumns;
  procedure SetDimensions(Row,Col: integer);
  property Value[Row,Col: integer]: Double read Get write Put; default;
  function BackSubstitute: TDoubleDynArray;
  procedure GausianElimination;
  function GaussBackSubsituation: TDoubleDynArray;
  procedure GaussJordanElimination;
  procedure ExchangeRows(R1, R2: integer);
  function MatrixStr(Digits: integer): string;
 end;


{ T2DMatrix }


procedure T2DMatrix.SetDimensions(Row, Col: integer);
begin
FRows:=Row; FColumns:=Col;
SetLength(FDoubleArray,Row * Col);
end;

constructor T2DMatrix.Create(Row, Col: integer);
begin
SetDimensions(Row, Col);
end;


procedure T2DMatrix.Put(Row,Col: integer; Item: double);
{Insert Double at index}
var Inx: integer;
begin
Inx:=(Col * Rows) + Row;
FDoubleArray[Inx]:=Item;
end;


function T2DMatrix.Get(Row,Col: integer): double;
{Get Double at the index}
var Inx: integer;
begin
Inx:=(Col * Rows) + Row;
Result:=FDoubleArray[Inx];
end;

{Matrix operations}

procedure T2DMatrix.ExchangeRows(R1,R2: integer);
{Exchange the specified Rows}
var Col: integer;
var T: double;
begin
for Col:=0 to Self.Columns-1 do
	begin
	T:=Self[R1,Col];
	Self[R1,Col]:=Self[R2,Col];
	Self[R2,Col]:=T;
	end;
end;



procedure T2DMatrix.GausianElimination;
var I,K,J : Integer;
var S : double;
{Small value to prevent divide by zero}
const Epsilon = 5.0e-162;
begin
{Do gaussian elimination and convert Row Echelon}
K:=0;
while True do
	begin
	{If the pivot is zero, find another row with non-zero in the same column}
	if Self[K,K]=0 then
		begin
		for I:=K+1 to Self.Rows-1 do
		 if Self[I,K]<>0 then
		 	begin
		 	Self.ExchangeRows(K,I);
		 	break;
		 	end;
		 end;

	{Get pivot again}
	S:=Self[K,K];
	{if it is still zero, prevent divide by zero}
	if S=0.0 then S:=Epsilon;
	{Use "scaling primative row operation" to set pivot to one i.e divide each item by pivot}
	for J:=K to Self.Columns-1 do Self[K,J]:=Self[K,J]/S;
	{Exit if we are on the bottom row}
	if K>=Self.Rows-1 then break;
	{Now that the previous row has 1 in the leading coefficient (Pivot)}
	{We convert all remaining columns below this item to zero }
	{Using "pivot primative row operation" = Current Row - Pivot * Start Row}
	for I:=K+1 to Self.Rows-1 do
		{Do this to current column for all remaining rows}
		begin
		{Get the leading coefficient}
		S:=Self[I,K];
		{Use it to zero column and apply to all items in row}
		for J:=K to Self.Columns-1 do Self[I,J]:=Self[I,J]-S*Self[K,J];
		end;
	{Point to next pivot}
	K:=K+1;
	end;
{Matrix is now in Row Echelon form }
end;




function T2DMatrix.BackSubstitute: TDoubleDynArray;
var Row,J: integer;
var Sum: double;
begin
SetLength(Result,Self.Rows);
for Row:=Self.Rows-1 downto 0 do
	begin
	Result[Row]:=Self[Row,Self.Columns-1];
	Sum:=0;
	for J:=Self.Rows-1 downto Row+1 do
        Sum:=Sum + Result[J] * Self[Row,J];
	Result[Row]:=Result[Row] - Sum;
	end;
end;



function T2DMatrix.GaussBackSubsituation: TDoubleDynArray;
begin
Self.GausianElimination;
Result:=Self.BackSubstitute;
end;



procedure T2DMatrix.GaussJordanElimination;
{ Do Gauss Jordan Elimination }
var I,K,J : Integer;
var S : double;
var X,Y: integer;
var Str: string;
{Small value to prevent divide by zero}
const Epsilon = 5.0e-162;
begin
{Do Gaussian Elimination to put matrix in Row Echelon format}
Self.GausianElimination;
{Now do the Jordan part to put it in Reduced Row Echelon form}
{Point K at the both the source row and target column (left part of matrix is square)}
K:=Self.Rows-1;
while K>0 do
	begin
	{Point I at the target row}
	I:=K-1;
	repeat
		begin
		{Get the coefficient of target column and row, the value we want to zero }
		S:=Self[I,K];
		{Multiply source row by the target coefficient and subtract from each item in the target row}
		{Since the target column is one in the source row, this will zero out the target coefficient}
		for J:=K to Self.Columns-1 do Self[I,J]:=Self[I,J]-S*Self[K,J];
		{Point to previous row}
		I:=I-1;
		end
	until I<0;
	{Point to previous column}
	K:=K-1;
	end;
end;



function T2DMatrix.MatrixStr(Digits: integer): string;
var Row,Col: integer;
begin
Result:=IntToStr(Self.Rows)+'X'+IntToStr(Self.Columns)+CRLF_Char;
for Row:=0 to Self.Rows-1 do
	begin
	Result:=Result+'[';
	for Col:=0 to Self.Columns-1 do
		begin
		if Col<>0 then Result:=Result+'  ';
		Result:=Result+FloatToStrF(Self[Row,Col],ffFixed,18,Digits);
		end;
	Result:=Result+']'+CRLF_Char;
	end;
end;

{===============================================================================}

procedure SolveEquations(Memo: TMemo);
var Mat: T2DMatrix;
var DA: TDoubleDynArray;
var I: integer;
var S: string;
begin
Mat:=T2DMatrix.Create(2,3);
try
{3x + y = -1}
{2x - 3y = -19}
Mat[0,0]:=3; Mat[0,1]:=1; Mat[0,2]:=-1;
Mat[1,0]:=2; Mat[1,1]:=-3; Mat[1,2]:=-19;
Memo.Lines.Add('Solve with Gaussian Elimination and Substitution');
Memo.Lines.Add('------------------------------------------------');
Memo.Lines.Add(Mat.MatrixStr(1));
Mat.GausianElimination;
Memo.Lines.Add('Row Echelon after Gaussian Elimination');
Memo.Lines.Add(Mat.MatrixStr(1));
DA:=Mat.BackSubstitute;
Memo.Lines.Add('Matrix after Back Substitution');
Memo.Lines.Add(Mat.MatrixStr(1));
Memo.Lines.Add(Format('Solution: X=%2.2f, Y=%2.2f',[DA[0],DA[1]]));

Mat[0,0]:=3; Mat[0,1]:=1; Mat[0,2]:=-1;
Mat[1,0]:=2; Mat[1,1]:=-3; Mat[1,2]:=-19;

Memo.Lines.Add('');
Memo.Lines.Add('Solve with Gaussian Jordan elimination');
Memo.Lines.Add('--------------------------------------');
Memo.Lines.Add(Mat.MatrixStr(1));
Mat.GaussJordanElimination;
Memo.Lines.Add('Matrix after Gauss-Jordan');
Memo.Lines.Add(Mat.MatrixStr(1));
Memo.Lines.Add(Format('Solution: X=%2.2f, Y=%2.2f',[Mat[0,2],Mat[1,2]]));
finally Mat.Free; end;
end;

