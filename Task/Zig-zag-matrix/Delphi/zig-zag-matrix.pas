type TMatrix = array of array of double;



procedure DisplayMatrix(Memo: TMemo; Mat: TMatrix);
{Display specified matrix}
var X,Y: integer;
var S: string;
begin
S:='';
for Y:=0 to High(Mat[0]) do
	begin
	S:=S+'[';
	for X:=0 to High(Mat) do
	  S:=S+Format('%4.0f',[Mat[X,Y]]);
	S:=S+']'+#$0D#$0A;
	end;
Memo.Lines.Add(S);
end;

procedure ZigzagMatrix(Memo: TMemo);
var Mat: TMatrix;
var X,Y,Inx,Dir: integer;
const Size = 10;

	procedure Toggle(var I: integer);
	{Toggle Direction and increment I}
	begin
	Dir:=-Dir;
	Inc(I);
	end;


	procedure Step(var X,Y: integer);
	{Take one step "Dir" direction}
	begin
	X:=X+Dir;
	Y:=Y-Dir;
	end;

begin
SetLength(Mat,Size,Size);
Inx:=0; X:=0; Y:=0; Dir:=1;
repeat
	begin
	Mat[X,Y]:=Inx;
	if (X+Dir)>=Size then Toggle(Y)
	else if (Y-Dir)>=Size then Toggle(X)
	else if (X+Dir)<0 then Toggle(Y)
	else if (Y-Dir)<0 then Toggle(X)
	else Step(X,Y);
	Inc(Inx);
	end
until Inx>=Size*Size;
DisplayMatrix(Memo,Mat);
end;
