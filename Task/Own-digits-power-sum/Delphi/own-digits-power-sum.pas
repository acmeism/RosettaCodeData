{Table to speed up power(X,Y) calculation }

const PowerTable: array [0..9] of array [0..9] of integer = (
(1, 0,  0,   0,    0,     0,      0,      0,        0,         0),
(1, 1,  1,   1,    1,     1,      1,      1,        1,         1),
(1, 2,  4,   8,   16,    32,     64,    128,      256,       512),
(1, 3,  9,  27,   81,   243,    729,   2187,     6561,     19683),
(1, 4, 16,  64,  256,  1024,   4096,  16384,    65536,    262144),
(1, 5, 25, 125,  625,  3125,  15625,  78125,   390625,   1953125),
(1, 6, 36, 216, 1296,  7776,  46656, 279936,  1679616,  10077696),
(1, 7, 49, 343, 2401, 16807, 117649, 823543,  5764801,  40353607),
(1, 8, 64, 512, 4096, 32768, 262144, 2097152, 16777216, 134217728),
(1, 9, 81, 729, 6561, 59049, 531441, 4782969, 43046721, 387420489)
);



procedure DigitsPowerSum(Memo: TMemo; var  Number, DigitCount: integer; Level, Sum: integer);
{Recursively process DigitCount power}
var Digits: integer;
begin
{Finish when recursion = Level Zero}
if Level = 0 then
	begin
	for Digits:= 0 to 9 do
		begin
		{Test combinations of digits and previous sum against number}
		if ((Sum + PowerTable[Digits, DigitCount]) = Number) and
		    (Number >= 100) then
			begin
			Memo.Lines.Add(IntToStr(DigitCount)+' '+IntToStr(Number));
			end;
		Inc(Number);
		{Keep track of digit count - increases on even power of 10}
		case Number of
		 10, 100, 1000, 10000, 100000,
		 1000000, 10000000, 100000000: Inc(DigitCount);
		 end;
		end;
	end
else for Digits:= 0 to 9 do
	begin
	{Recurse through all digits/levels}
	DigitsPowerSum(Memo, Number, DigitCount,
		       Level-1, Sum + PowerTable[Digits, DigitCount]);
	end;
end;


procedure ShowDigitsPowerSum(Memo: TMemo);
var  Number, DigitCount: integer;
begin
Number:= 0;
DigitCount:= 1;
DigitsPowerSum(Memo, Number, DigitCount, 9-1, 0);
end;
