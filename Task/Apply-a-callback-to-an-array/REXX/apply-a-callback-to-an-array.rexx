/*REXX pgm applies a callback to an array (using factorials for demonstration)*/
a.=;     b.=;         a.0  =  0
                      a.1  =  1
                      a.2  =  2
                      a.3  =  3
                      a.4  =  4
                      a.5  =  5
                      a.6  =  6
                      a.7  =  7
                      a.8  =  8
                      a.9  =  9
                      a.10 = 10
call listAB  'before'
call bangit  'a','b'           /*factorialize the A array, store results───►B.*/
call listAB  ' after'
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
bangit:   do i=0;    _=value(arg(1)'.'i);         if _=='' then return
          call value arg(2)'.'i, fact(_)
          end    /*i*/
/*────────────────────────────────────────────────────────────────────────────*/
fact: procedure; !=1;        do j=2  to arg(1);   !=!*j;   end;         return !
/*────────────────────────────────────────────────────────────────────────────*/
listAB:   do j=0  while a.j\=='';    say arg(1) 'a.'j"="a.j;    end  /*j*/;  say
          do k=0  while b.k\=='';    say arg(1) 'b.'k"="b.k;    end  /*k*/
return
