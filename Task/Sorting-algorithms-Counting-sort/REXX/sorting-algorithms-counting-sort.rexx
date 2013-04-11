/*REXX program sorts an array using the  count-sort  method.            */
call gen@                              /*generate the array elements.   */
call show@ 'before sort'               /*show the before array elements.*/
call countSort  N                      /*sort N entries of the @. array.*/
call show@ ' after sort'               /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────countSort subroutine────────────────*/
countSort:  procedure expose @.;     parse arg N;      h=@.1;        L=h

           do i=2  to N;   L=min(L,@.i);     h=max(h,@.i)
           end   /*i*/

_.=0;      do j=1  for N;  x=@.j;            _.x=_.x+1
           end   /*j*/

#=1;       do k=L  to h;   if _.k\==0  then  do #=#  for _.k
                                             @.#=k
                                             end   /*#*/
           end   /*k*/
return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: @.=                              /*assign  40  Recaman  numbers.  */
@.1 =   1 ;     @.9 =  21 ;     @.17=  25 ;     @.25=  17 ;     @.33=  79
@.2 =   3 ;     @.10=  11 ;     @.18=  43 ;     @.26=  43 ;     @.34= 113
@.3 =   6 ;     @.11=  22 ;     @.19=  62 ;     @.27=  16 ;     @.35=  78
@.4 =   2 ;     @.12=  10 ;     @.20=  42 ;     @.28=  44 ;     @.36= 114
@.5 =   7 ;     @.13=  23 ;     @.21=  63 ;     @.29=  15 ;     @.37=  77
@.6 =  13 ;     @.14=   9 ;     @.22=  41 ;     @.30=  45 ;     @.38=  39
@.7 =  20 ;     @.15=  24 ;     @.23=  18 ;     @.31=  14 ;     @.39=  78
@.8 =  12 ;     @.16=   8 ;     @.24=  42 ;     @.32=  46 ;     @.40=  38

        do N=1  while @.N\=='';  end   /*determine the number of entries*/
N=N-1                                  /*adjust highItem slightly.      */
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: widthH=length(N)                /*max width of any element number*/
pad=left('',9);         do s=1  for N
                        say pad  'element' right(s,widthH) arg(1)": "  @.s
                        end   /*s*/
say copies('─',40)                     /*show a pretty separator line.  */
return
