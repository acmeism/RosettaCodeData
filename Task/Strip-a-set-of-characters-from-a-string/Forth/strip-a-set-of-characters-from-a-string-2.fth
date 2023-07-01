: ?exit ( c1 c2 -- ) ]] = if drop unloop exit then [[ ; immediate
: .stripped ( a u c -- ) -rot bounds ?do dup i c@ ?exit loop emit ;
: stripchars ( a1 u1 a2 u2 -- ) bounds ?do 2dup i c@ .stripped loop 2drop ;

: "aei" s" aei" ;

\ usage: "aei" s" She was a soul stripper. She took my heart!" stripchars
