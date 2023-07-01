removeDups =: {.;.1~ (1 , }. ~: }: )
codes  =: ;: 'BFPV CGJKQSXZ DT L MN R HW'

soundex =: 3 : 0
 if. 0=# k=.toupper y do. '0' return. end.
 ({.k), ,": ,. 3 {. 0-.~ }. removeDups 7 0:`(I.@:=)`]} , k >:@I.@:(e. &>)"0 _ codes
)
