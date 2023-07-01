: r2cf ( num1 den1 -- num2 den2 )  swap over >r s>d r> sm/rem . ;

: .r2cf ( num den -- )
  cr 2dup swap . ." / " . ." : "
  begin
  r2cf dup 0<> while
  repeat 2drop ;

: r2cf-demo
            1 2 .r2cf
            3 1 .r2cf
            23 8 .r2cf
            13 11 .r2cf
            22 7 .r2cf
            -151 77 .r2cf
            14142 10000 .r2cf
            141421 100000 .r2cf
            1414214 1000000 .r2cf
            14142136 10000000 .r2cf
            31 10 .r2cf
            314 100 .r2cf
            3142 1000 .r2cf
            31428 10000 .r2cf
            314285 100000 .r2cf
            3142857 1000000 .r2cf
            31428571 10000000 .r2cf
            314285714 100000000 .r2cf
            3141592653589793 1000000000000000 .r2cf ;
r2cf-demo
