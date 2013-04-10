/*REXX program to apply a  callback  to a  stemmed  (REXX)  array.      */
        a.=;   b.=
 a.0= 0
 a.1= 1
 a.2= 2
 a.3= 3
 a.4= 4
 a.5= 5
 a.6= 6
 a.7= 7
 a.8= 8
 a.9= 9
a.10=10

call listab 'before'
call bangit 'a','b'      /*factorialize the A array, store results in B */
call listab ' after'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────BANGIT subroutine───────────────────*/
bangit:   do i=0
          _=value(arg(1)'.'i);    if _=='' then return
          call value arg(2)'.'i,fact(_)
          end    /*i*/
/*──────────────────────────────────FACT subroutine─────────────────────*/
fact: procedure; !=1; do j=2 to arg(1); !=!*j; end; return !
/*──────────────────────────────────LISTAB subroutine───────────────────*/
listab: do j=0  while a.j\=='';     say arg(1) 'a.'j"="a.j;     end  /*j*/
say;    do k=0  while b.k\=='';     say arg(1) 'b.'k"="b.k;     end  /*k*/
return
