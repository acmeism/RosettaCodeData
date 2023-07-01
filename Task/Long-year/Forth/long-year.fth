: dec31wd ( year -- weekday ) dup dup 4 / swap dup 100 / swap 400 / swap - + + 7 mod ;
: long? ( year -- flag ) dup dec31wd 4 = if drop 1 else 1 - dec31wd 3 = if 1 else 0 then then ;
: demo ( startyear endyear -- ) cr swap do i long? if i . then loop cr ;
