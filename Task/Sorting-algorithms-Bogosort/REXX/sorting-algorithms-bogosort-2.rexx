/*REXX program performs a type of  bogo sort  on numbers in an array.   */
@.1 =   0  ;     @.11=    -64  ;     @.21=     4096  ;    @.31=    6291456
@.2 =   0  ;     @.12=     64  ;     @.22=    40960  ;    @.32=    5242880
@.3 =   1  ;     @.13=    256  ;     @.23=    16384  ;    @.33=  -15728640
@.4 =   2  ;     @.14=      0  ;     @.24=  -114688  ;    @.34=  -27262976
@.5 =   0  ;     @.15=   -768  ;     @.25=  -131072  ;    @.35=   29360128
@.6 =  -4  ;     @.16=   -512  ;     @.26=   262144  ;    @.36=  104857600
@.7 =   0  ;     @.17=   2048  ;     @.27=   589824  ;    @.37=  -16777216
@.8 =  16  ;     @.18=   3072  ;     @.28=  -393216  ;    @.38= -335544320
@.9 =  16  ;     @.19=  -4096  ;     @.29= -2097152  ;    @.39= -184549376
@.10= -32  ;     @.20= -12288  ;     @.30=  -262144  ;    @.40=  905969664
                          /* [↑]   @.1  is really the 0th Berstel number*/
#=40                      /*we have a list of two score Berstel numbers.*/
call tell 'before bogo sort'

  do bogo=1

    do j=1  for #;   ?=@.j             /*?  is the next number in array.*/

      do k=j+1  to #
      if @.k>=?  then iterate          /*is this # in order?  Get next. */
                                       /*get 2 unique random #s for swap*/
         do  until a\==b;  a=random(j, k);     b=random(j, k);    end

      parse value @.a @.b  with  @.b @.a    /*swap 2 random #s in array.*/
      iterate bogo                     /*go and try another bogo sort.  */
      end   /*k*/
    end     /*j*/

  leave                                /*we're finished with bogo sort. */
  end       /*bogo*/                   /* [↓]  show the # of bogo sorts.*/

say 'number of bogo sorts performed =' bogo
call tell ' after bogo sort'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell:  say;  say center(arg(1), 50, '─')
                 do t=1  for #
                 say arg(1)  'element'right(t, length(#))'='right(@.t, 18)
                 end   /*t*/
say
return
