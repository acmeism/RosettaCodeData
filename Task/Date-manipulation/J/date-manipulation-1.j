require'dates'
months=: <;._2 tolower 0 :0
January
February
March
April
May
June
July
August
September
October
November
December
)

numbers=: _".' '"_`(1 I.@:-e.&(":i.10)@])`]}~
words=: [:;:@tolower' '"_`(I.@(tolower = toupper)@])`]}~
getyear=: >./@numbers
getmonth=: 1 + months <./@i. words
getday=: {.@(numbers -. getyear)
gethour=: (2 { numbers) + 12 * (<'pm') e. words
getminsec=: 2 {. 3}. numbers

getts=: getyear, getmonth, getday, gethour, getminsec
timeadd=: 1&tsrep@+&tsrep
deltaT=: (1 tsrep 0)&([ + -@#@[ {. ])
