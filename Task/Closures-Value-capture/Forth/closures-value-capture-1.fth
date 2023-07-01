: xt-array here { a }
    10 cells allot 10 0 do
	:noname i ]] literal dup * ; [[ a i cells + !
    loop a ;

xt-array 5 cells + @ execute .
