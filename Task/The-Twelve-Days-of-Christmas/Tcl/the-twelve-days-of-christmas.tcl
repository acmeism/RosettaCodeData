set days {
    first second third fourth fifth sixth
    seventh eighth ninth tenth eleventh twelfth
}
set gifts [lreverse {
    "A partridge in a pear tree."
    "Two turtle doves, and"
    "Three french hens,"
    "Four calling birds,"
    "Five golden rings,"
    "Six geese a-laying,"
    "Seven swans a-swimming,"
    "Eight maids a-milking,"
    "Nine ladies dancing,"
    "Ten lords a-leaping,"
    "Eleven pipers piping,"
    "Twelve drummers drumming,"
}]

set n -1;puts [join [lmap day $days {
    format "On the $day day of Christmas,\nMy true love gave to me:\n%s" \
	    [join [lrange $gifts end-[incr n] end] \n]
}] \n\n]
