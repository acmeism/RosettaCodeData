type T5Matrix = array[0..4, 0..4] of Double;

var TestMatrix: T5Matrix =
    	(( 1,  3,  7,  8, 10),
	 ( 2,  4, 16, 14,  4),
	 ( 3,  1,  9, 18, 11),
	 (12, 14, 17, 18, 20),
	 ( 7,  1,  3,  9,  5));


function BottomTriangleSum(Mat: T5Matrix): double;
var X,Y: integer;
begin
Result:=0;
for Y:=1 to 4 do
 for X:=0 to Y-1 do
	begin
	Result:=Result+Mat[Y,X];
	end;
end;


procedure ShowBottomTriangleSum(Memo: TMemo);
var Sum: double;
begin
Sum:=BottomTriangleSum(TestMatrix);
Memo.Lines.Add(IntToStr(Trunc(Sum)));
end;
