nth := ["first","second","third","fourth","fifth","sixth","seventh","eighth","ninth","tenth","eleventh","twelfth"]
lines := ["A partridge in a pear tree."
		,"Two turtle doves and"
		,"Three french hens"
		,"Four calling birds"
		,"Five golden rings"
		,"Six geese a-laying"
		,"Seven swans a-swimming"
		,"Eight maids a-milking"
		,"Nine ladies dancing"
		,"Ten lords a-leaping"
		,"Eleven pipers piping"
		,"Twelve drummers drumming"]

full:="", mid:=""
loop % lines.MaxIndex()
{
	top:="On the " . nth[A_Index] . " day of Christmas,`nMy true love gave to me:"
	mid:= lines[A_Index] . "`n" . mid
	full:= full . top . "`n" . mid . ((A_Index<lines.MaxIndex())?"`n":"")
}
MsgBox % full
