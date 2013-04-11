/*REXX program;to perform a type of bogo sort on an array.              */
                           /*a.1  is really the  0th  Berstel number... */
a.1 =   0  ;     a.11=    -64  ;     a.21=     4096  ;    a.31=    6291456
a.2 =   0  ;     a.12=     64  ;     a.22=    40960  ;    a.32=    5242880
a.3 =   1  ;     a.13=    256  ;     a.23=    16384  ;    a.33=  -15728640
a.4 =   2  ;     a.14=      0  ;     a.24=  -114688  ;    a.34=  -27262976
a.5 =   0  ;     a.15=   -768  ;     a.25=  -131072  ;    a.35=   29360128
a.6 =  -4  ;     a.16=   -512  ;     a.26=   262144  ;    a.36=  104857600
a.7 =   0  ;     a.17=   2048  ;     a.27=   589824  ;    a.37=  -16777216
a.8 =  16  ;     a.18=   3072  ;     a.28=  -393216  ;    a.38= -335544320
a.9 =  16  ;     a.19=  -4096  ;     a.29= -2097152  ;    a.39= -184549376
a.10= -32  ;     a.20= -12288  ;     a.30=  -262144  ;    a.40=  905969664

size=40                   /*we have a list of two score Berstel numbers.*/
call tell 'un-bogoed'

  do bogo=1

    do j=1  for size
    _=a.j

      do k=j+1  to size
      if a.k>=_  then iterate
      n=random(j,k)               /*we have an num out of order.get rand*/
        do forever; m=random(j,k) /*get another random number.*/
        if m\==n  then leave      /*ensure we're not swapping the same #*/
        end   /*forever*/
      parse value a.n a.m with a.m a.n  /*swap 2 random nums*/
      iterate bogo
      end    /*k*/
    end      /*j*/

  leave
  end       /*bogo*/

say 'number of bogo sorts performed =' bogo-1
call tell '   bogoed'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell: say;   say center(arg(1),40,'─')

           do j=1  to size
           say arg(1)  'element'right(j,length(size))'='right(a.j,20)
           end   /*j*/
say
return
