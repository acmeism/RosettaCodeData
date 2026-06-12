{Define a matrix}

type TMatrix = array of array of double;

procedure DisplayMatrix(Memo: TMemo; Mat: TMatrix);
{Display specified matrix}
var X,Y: integer;
var S: string;
begin
S:='';
for Y:=0 to High(Mat) do
  begin
  S:=S+'[';
  for X:=0 to High(Mat[0]) do
    if X=0 then S:=S+Format('%0.0f',[Mat[X,Y]])
    else S:=S+Format('%2.0f',[Mat[X,Y]]);
  S:=S+']'+#$0D#$0A;
  end;
Memo.Lines.Add(S);
end;


procedure ClearMatrix(var Mat: TMatrix; Value: double);
{Set all elements of the matrix to specified value}
var X,Y: integer;
begin
for Y:=0 to High(Mat) do
 for X:=0 to High(Mat[0]) do Mat[X,Y]:=0;
end;

procedure SetMosaicMatrix(var Mat: TMatrix);
{Set matrix to mosaic pattern}
var X,Y: integer;
begin
{Set every other cell to one or zero}
for Y:=0 to High(Mat) do
 for X:=0 to High(Mat) do Mat[X,Y]:=(X+Y+1) mod 2;
end;


procedure BuildMosaicMatrix(var Mat: TMatrix; Size: integer);
{Build a matrix with diagonals of the specified size }
var X,Y: integer;
begin
SetLength(Mat,Size,Size);
ClearMatrix(Mat,0);
SetMosaicMatrix(Mat);
end;

procedure BuildShowMosaicMatrix(Memo: TMemo; var Mat: TMatrix; Size: integer);
{Build and show a matrix of specific size}
begin
Memo.Lines.Add(Format('Matrix = %2d X %2d',[Size,Size]));
BuildMosaicMatrix(Mat,Size);
DisplayMatrix(Memo,Mat);
end;


procedure DisplayMosaicMatrices(Memo: TMemo);
{Build and display matrices of various sizes}
var Mat: TMatrix;
var I: integer;
begin
for I:=3 to 10 do BuildShowMosaicMatrix(Memo,Mat,I);
end;

