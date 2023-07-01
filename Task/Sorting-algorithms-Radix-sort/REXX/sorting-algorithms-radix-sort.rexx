/*REXX program performs a radix sort on an integer array (can be negative/zero/positive)*/
call gen                                         /*call subroutine to generate numbers. */
call radSort  n, w                               /*invoke the  radix sort  subroutine.  */
call show                                        /*display the elements in the  @  array*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen: ILF=  0  2  3  4  5  5  7. 6  6  7 11  7 13  9  8  8 17  8 19  9 10 13 23  9 10 15 ,
           9 11 29 10 31 10 14 19 12 10 37 21 16 11 41 12 43 15 11 25 47 11 14 12 20 17 ,
          53 11 16 13 22 31 59 12 61 33 13 12 18 16 67 21 26 14 71 12 73 39 13 23 18 18 ,
          79 13 12 43 83 14 22 45 32 17 89 13 20 27 34 49 24 13 97 16 17 14  101        ,
         '22 103 19 15 55 107 13 109 18 40 15 113  -42'
              /*excluding -42, abbreviated above list is called the integer log function*/
     n= words(ILF)                                            /*    I────── L── F───────*/
     w= 0;         do m=1  for n;   _= word(ILF,m) +0;    @.m= _;    w= max(w, length(_) )
                   end   /*m*/;        return    /*W:  is the maximum width ↑ of numbers*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
radSort: procedure expose @.;  parse arg size,w;   mote= c2d(' ');    #= 1;   !.#._n= size
!.#._b= 1;                     if w==''  then w= 8
!.#._i= 1;  do i=1  for size;  y=@.i;  @.i= right(abs(y), w, 0);  if y<0  then @.i= '-'@.i
            end  /*i*/                                            /* [↑]  negative case.*/

     do  while #\==0;  ctr.= 0;  L= 'ffff'x;   low= !.#._b;   n= !.#._n;   $= !.#._i;   H=
     #= #-1                                                      /* [↑]   is the radix. */
           do j=low  for n;      parse var  @.j  =($)  _  +1;    ctr._= ctr._ + 1
           if ctr._==1 & _\==''  then do;  if _<<L  then L=_;    if _>>H  then H=_
                                      end  /*  ↑↑                                       */
           end   /*j*/                     /*  └┴─────◄───  <<   is a strict comparison.*/
     _=                                    /*      ┌──◄───  >>    " "    "        "     */
     if L>>H  then iterate                 /*◄─────┘                                    */
     if L==H & ctr._==0  then do; #= #+1;  !.#._b= low;  !.#._n= n;  !.#._i= $+1;  iterate
                              end
     L= c2d(L);   H= c2d(H);      ?= ctr._ + low;        top._= ?;          ts= mote
     max= L
                  do k=L  to H;   _= d2c(k, 1);   c= ctr._  /* [↓]  swap 2 item radices.*/
                  if c>ts  then parse value  c k  with  ts max;     ?= ?+c;       top._= ?
                  end   /*k*/
     piv= low                                    /*set PIVot to the low part of the sort*/
             do  while piv<low+n
             it= @.piv
                        do forever;     parse var it  =($)  _  +1;         c= top._ -1
                        if piv>=c  then leave;   top._= c;    ?= @.c;    @.c= it;    it= ?
                        end   /*forever*/
             top._= piv;                         @.piv= it;        piv= piv + ctr._
             end   /*while piv<low+n */
     i= max
          do  until i==max;  _= d2c(i, 1);     i= i+1;     if i>H  then i= L;     d= ctr._
          if d<=mote  then do;         if d<2  then iterate;          b= top._
                             do k=b+1  for d-1;                       q= @.k
                               do j=k-1  by -1  to b  while q<<@.j;  jp= j+1;   @.jp= @.j
                               end   /*j*/
                                                                     jp= j+1;   @.jp= q
                             end     /*k*/
                           iterate
                           end
          #= #+1;       !.#._b= top._;       !.#._n= d;        !.#._i= $ + 1
          end   /*until i==max*/
     end        /*while #\==0 */
#= 0                                             /* [↓↓↓]  handle neg. and pos. arrays. */
        do i=size  by -1  for size;    if @.i>=0  then iterate;     #= #+1;      @@.#= @.i
        end   /*i*/
        do j=1  for size;   if @.j>=0  then do;  #= #+1;   @@.#= @.j;  end;    @.j= @@.j+0
        end   /*j*/                              /* [↑↑↑]  combine 2 lists into 1 list. */
return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  do j=1  for n;   say 'item'   right(j, w)   "after the radix sort:"   right(@.j, w)
       end   /*j*/;     return                   /* [↑]  display sorted items ───► term.*/
