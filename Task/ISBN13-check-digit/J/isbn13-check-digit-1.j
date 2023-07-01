   D            =:  '0123456789'

   isbn13c      =:  D&([ check@:i. clean)
     check      =:  0 = 10 | lc
       lc       =:  [ +/@:* weight
         weight =:  1 3 $~ #
     clean      =:  ] -. a. -. [
