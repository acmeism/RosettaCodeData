const GiftList: array [0..11] of string =(
	'a partridge in a pear tree.',
	'Two turtle doves',
	'Three french hens',
	'Four calling birds',
	'Five golden rings',
	'Six geese a-laying',
	'Seven swans a-swimming',
	'Eight maids a-milking',
	'Nine ladies dancing',
	'Ten lords a-leaping',
	'Eleven pipers piping',
	'Twelve drummers drumming');

const Cardinals: array [0..11] of string =
	('first','second','third','forth',
	'fifth','sixth','seventh','eight',
	'ninth','tenth','eleventh','twelfth');

procedure DoOneDay(Memo: TMemo; Day: integer);
var S: string;
var I: integer;
begin
S:='On the '+Cardinals[Day]+' of Christmas ';
S:=S+'my true love gave to me'+CRLF;
for I:=Day downto 0 do
	begin
	if (Day>0) and (I=0) then S:=S+'and ';
	S:=S+GiftList[I]+CRLF;
	end;
Memo.Lines.Add(S);
end;

procedure TwelveDaysOfChristmas(Memo: TMemo);
var I: integer;
begin
for I:=0 to 12-1 do DoOneDay(Memo,I);
end;
