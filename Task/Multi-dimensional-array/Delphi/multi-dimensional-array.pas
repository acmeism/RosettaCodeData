{1. Delphi support arrays of any number of dimensions, including non-orthogonal arrays.}
{2. Delphi arrays are Row Major.}
{3. This creates a five dimensional array in Delphi.}

var MyArray: array [0..5,0..4,0..3,0..2] of integer;

{4. This reads and writes array items:}

MyArray[5,4,3,2]:=MyArray[1,2,3,2];

{5. Array memory space can be compacted to guarantee that all items are contiguous.}

var MyArray3: packed array [0..5,0..4,0..3,0..2] of integer;

{6. You can create array that start at indices other than zero.}

var MyArray2: array [5..25,26..50] of integer;

{7. You can create non-orthogonal arrays:}

var  A : array of array of string;
var  I, J : Integer;
begin
SetLength(A, 10);
for I := Low(A) to High(A) do
	begin
	SetLength(A[I], I);
	for J := Low(A[I]) to High(A[I]) do
	A[I,J] := IntToStr(I) + ',' + IntToStr(J) + ' ';
	end;
end;
