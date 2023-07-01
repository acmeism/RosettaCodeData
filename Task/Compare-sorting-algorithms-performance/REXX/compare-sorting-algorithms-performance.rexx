/*REXX pgm compares various sorts for 3 types of input sequences: ones/ascending/random.*/
parse arg ranges start# seed .                   /*obtain optional arguments from the CL*/
if ranges=='' | ranges==","  then ranges=     5  /*Not Specified?  Then use the default.*/
if start#=='' | start#==","  then start#=   250  /* "      "         "   "   "     "    */
if   seed=='' |   seed==","  then   seed=  1946  /*use a repeatable seed for RANDOM  BIF*/
if datatype(seed, 'W')  then call random ,,seed  /*Specified?  Then use as a RANDOM seed*/
kinds= 3;      hdr=;       #= start#             /*hardcoded/fixed number of datum kinds*/
   do ra=1  for ranges
   hdr= hdr || center( commas(#) "numbers", 25)'│'  /*(top) header for the output title.*/
     do ki=1  for kinds
     call gen@@ #, ki
     call set@;  call time 'R';  call bubble     #;     bubble.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call cocktail   #;   cocktail.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call cocktailSB #; cocktailSB.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call comb       #;       comb.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call exchange   #;   exchange.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call gnome      #;      gnome.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call heap       #;       heap.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call insertion  #;  insertion.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call merge      #;      merge.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call pancake    #;    pancake.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call quick      #;      quick.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call radix      #;      radix.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call selection  #;  selection.ra.ki= format(time("E"),,2)
     call set@;  call time 'R';  call shell      #;      shell.ra.ki= format(time("E"),,2)
     end   /*ki*/
   #= # + #                                                         /*double # elements.*/
   end     /*ra*/
say;                             say;    say                        /*say blank sep line*/
say center('         ', 11     ) "│"left(hdr, length(hdr)-1)"│"     /*replace last char.*/
                            reps= ' allONES  ascend  random │'      /*build a title bar.*/
xreps=       copies( center(reps, length(reps)), ranges)            /*replicate ranges. */
creps= left(xreps, length(xreps)-1)"│"                              /*replace last char.*/
say center('sort type', 11     ) "│"creps;                       Lr= length(reps)
                                        xcreps= copies( left('', Lr-1, '─')"┼", ranges)
say center(''         , 12, '─')"┼"left(xcreps, length(xcreps)-1)"┤"
call show 'bubble'                               /* ◄──── show results for bubble  sort.*/
call show 'cocktail'                             /* ◄────   "     "     "  cocktail   " */
call show 'cocktailSB'    /*+Shifting Bounds*/   /* ◄────   "     "     "  cocktailSB " */
call show 'comb'                                 /* ◄────   "     "     "  comb       " */
call show 'exchange'                             /* ◄────   "     "     "  exchange   " */
call show 'gnome'                                /* ◄────   "     "     "  gnome      " */
call show 'heap'                                 /* ◄────   "     "     "  heap       " */
call show 'insertion'                            /* ◄────   "     "     "  insertion  " */
call show 'merge'                                /* ◄────   "     "     "  merge      " */
call show 'pancake'                              /* ◄────   "     "     "  pancake    " */
call show 'quick'                                /* ◄────   "     "     "  quick      " */
call show 'radix'                                /* ◄────   "     "     "  radix      " */
call show 'selection'                            /* ◄────   "     "     "  shell      " */
call show 'shell'                                /* ◄────   "     "     "  shell      " */
say translate(center(''         , 12, '─')"┴"left(xcreps, length(xcreps)-1)"┘",  '┴', "┼")
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
inOrder: parse arg n; do j=1  for n-1;  k= j+1;  if @.j>@.k  then return 0; end;  return 1
set@:   @.=;          do a=1  for #;                 @.a= @@.a;             end;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen@@: procedure expose @@.; parse arg n,kind;  nn= min(n, 100000)     /*1e5≡REXX's max.*/
              do j=1 for nn;      select
                                  when kind==1  then  @@.j= 1               /*all ones. */
                                  when kind==2  then  @@.j= j               /*ascending.*/
                                  when kind==3  then  @@.j= random(, nn)    /*random.   */
                                  end   /*select*/
              end   /*j*/;                                              return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  parse arg aa;  _= left(aa, 11)  "│"
                                do   ra=1  for ranges
                                  do ki=1  for kinds
                                  _= _  right( value(aa || . || ra || . || ki),  7, ' ')
                                  end   /*k*/
                                _= _  "│"
                                end     /*r*/;       say _;             return
/*──────────────────────────────────────────────────────────────────────────────────────*/
bubble:   procedure expose @.;  parse arg n         /*N: is the number of  @  elements. */
            do m=n-1  by -1  until ok;         ok=1 /*keep sorting  @  array until done.*/
              do j=1  for m;  k=j+1;  if @.j<=@.k  then iterate    /*elements in order? */
              _=@.j;  @.j=@.k;  @.k=_;         ok=0 /*swap 2 elements; flag as not done.*/
              end   /*j*/
            end     /*m*/;                                              return
/*──────────────────────────────────────────────────────────────────────────────────────*/
cocktail: procedure expose @.;    parse arg N;   nn= N-1     /*N:  is number of items.  */
            do until done;   done= 1
                do j=1   for nn;                jp= j+1
                if @.j>@.jp  then do;  done=0;  _=@.j;  @.j=@.jp;  @.jp=_;  end
                end   /*j*/
            if done  then leave                              /*No swaps done?  Finished.*/
                do k=nn  for nn  by -1;         kp= k+1
                if @.k>@.kp  then do;  done=0;  _=@.k;  @.k=@.kp;  @.kp=_;  end
                end   /*k*/
            end       /*until*/;                                        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
cocktailsb: procedure expose @.;    parse arg N              /*N:  is number of items.  */
                             end$= N - 1;     beg$= 1
            do while beg$ <= end$
            beg$$= end$;               end$$= beg$
                do j=beg$ to end$;                   jp= j + 1
                if @.j>@.jp  then do;  _=@.j;  @.j=@.jp;  @.jp=_;  end$$=j;  end
                end   /*j*/
            end$= end$$ - 1
                do k=end$  to beg$  by -1;           kp= k + 1
                if @.k>@.kp  then do;  _=@.k;  @.k=@.kp;  @.kp=_;  beg$$=k;  end
                end   /*k*/
            beg$= beg$$ + 1
            end       /*while*/;                                        return
/*──────────────────────────────────────────────────────────────────────────────────────*/
comb:  procedure expose @.;   parse arg n        /*N:  is the number of  @  elements.   */
       g= n-1                                    /*G:  is the gap between the sort COMBs*/
             do  until g<=1 & done;    done= 1   /*assume sort is done  (so far).       */
             g= g * 0.8  % 1                     /*equivalent to:   g= trunc( g / 1.25) */
             if g==0  then g= 1                  /*handle case of the gap is too small. */
                do j=1  until $>=n;    $= j + g  /*$:     a temporary index  (pointer). */
                if @.j>@.$  then do;   _= @.j;     @.j= @.$;    @.$= _;    done= 0;    end
                end   /*j*/                      /* [↑]  swap two elements in the array.*/
             end      /*until*/;       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
exchange: procedure expose @.;  parse arg n 1 h  /*both  N  and  H  have the array size.*/
             do while h>1;                      h= h % 2
                do i=1  for n-h;       j= i;    k= h+i
                   do while @.k<@.j
                   _= @.j;  @.j= @.k;  @.k= _;  if h>=j  then leave;  j= j-h;  k= k-h
                   end   /*while @.k<@.j*/
                end      /*i*/
             end         /*while h>1*/;                       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
gnome: procedure expose @.;  parse arg n;      k= 2               /*N: is number items. */
          do j=3  while k<=n;                  p= k - 1           /*P: is previous item.*/
          if @.p<<=@.k  then do;      k= j;    iterate;   end     /*order is OK so far. */
          _= @.p;       @.p= @.k;     @.k= _                      /*swap two @ entries. */
          k= k - 1;     if k==1  then k= j;    else j= j-1        /*test for 1st index. */
          end    /*j*/;                                return
/*──────────────────────────────────────────────────────────────────────────────────────*/
heap:  procedure expose @.; arg n;  do j=n%2  by -1  to 1;   call heapS j,n;  end  /*j*/
             do n=n  by -1  to 2;    _= @.1;    @.1= @.n;    @.n= _;   call heapS 1,n-1
             end   /*n*/;           return       /* [↑]  swap two elements; and shuffle.*/

heapS: procedure expose @.;  parse arg i,n;        $= @.i            /*obtain parent.*/
             do  while i+i<=n;   j= i+i;   k= j+1;    if k<=n  then  if @.k>@.j  then j= k
             if $>=@.j  then leave;      @.i= @.j;    i= j
             end   /*while*/;            @.i= $;      return            /*define lowest.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
insertion:  procedure expose @.;   parse arg n
                   do i=2  to n;   $= @.i;       do j=i-1  by -1  to 1  while @.j>$
                                                 _= j + 1;        @._= @.j
                                                 end   /*j*/
                   _= j + 1;       @._= $
                   end   /*i*/;                                         return
/*──────────────────────────────────────────────────────────────────────────────────────*/
merge: procedure expose @. !.;   parse arg n, L;   if L==''  then do;  !.=;  L= 1;  end
          if n==1  then return;     h= L + 1
          if n==2  then do; if @.L>@.h  then do; _=@.h; @.h=@.L; @.L=_; end; return;  end
          m= n % 2                                     /* [↑]  handle case of two items.*/
          call merge  n-m, L+m                         /*divide items  to the left   ···*/
          call merger m,   L,   1                      /*   "     "     "  "  right  ···*/
          i= 1;                     j= L + m
                     do k=L  while k<j                 /*whilst items on right exist ···*/
                     if j==L+n  |  !.i<=@.j  then do;     @.k= !.i;     i= i + 1;      end
                                             else do;     @.k= @.j;     j= j + 1;      end
                     end   /*k*/;                         return

merger: procedure expose @. !.;  parse arg n,L,T
           if n==1  then do;  !.T= @.L;                                       return;  end
           if n==2  then do;  h= L + 1;   q= T + 1;  !.q= @.L;    !.T= @.h;   return;  end
           m= n % 2                                    /* [↑]  handle case of two items.*/
           call merge  m,   L                          /*divide items  to the left   ···*/
           call merger n-m, L+m, m+T                   /*   "     "     "  "  right  ···*/
           i= L;                     j= m + T
                     do k=T  while k<j                 /*whilst items on left exist  ···*/
                     if j==T+n  |  @.i<=!.j  then do;     !.k= @.i;     i= i + 1;      end
                                             else do;     !.k= !.j;     j= j + 1;      end
                     end   /*k*/;                         return
/*──────────────────────────────────────────────────────────────────────────────────────*/
pancake: procedure expose @.;   parse arg n .;               if inOrder(n)  then return
             do n=n  by -1  for n-1
             != @.1;   ?= 1;                do j=2  to n;    if @.j<=!  then iterate
                                            != @.j;          ?= j
                                            end   /*j*/
             call panFlip ?;   call panFlip n
             end   /*n*/;                                               return

panFlip: parse arg y;  do i=1  for (y+1)%2; yi=y-i+1; _=@.i; @.i=@.yi; @.yi=_; end; return
/*──────────────────────────────────────────────────────────────────────────────────────*/
quick: procedure expose @.; a.1=1; parse arg b.1; $= 1 /*access @.; get #; define pivot.*/
       if inOrder(b.1)  then return
             do  while  $\==0;     L= a.$;    t= b.$;     $= $-1;   if t<2  then iterate
             H= L+t-1;             ?= L+t%2
             if @.H<@.L  then if @.?<@.H  then do;  p=@.H;  @.H=@.L;  end
                                          else if @.?>@.L  then p=@.L
                                                           else do;  p=@.?;  @.?=@.L;  end
                         else if @.?<@.L  then p=@.L
                                          else if @.?>@.H  then do;  p=@.H;  @.H=@.L;  end
                                                           else do;  p=@.?;  @.?=@.L;  end
             j= L+1;                           k=h
                    do forever
                        do j=j         while j<k & @.j<=p;  end     /*a tinie─tiny loop.*/
                        do k=k  by -1  while j<k & @.k>=p;  end     /*another   "    "  */
                    if j>=k  then leave                             /*segment finished? */
                    _= @.j;       @.j= @.k;             @.k= _      /*swap J&K elements.*/
                    end   /*forever*/
             $= $+1;            k= j-1;   @.L= @.k;     @.k= p
             if j<=?  then do;  a.$= j;   b.$= H-j+1;   $= $+1;  a.$= L;  b.$= k-L;    end
                      else do;  a.$= L;   b.$= k-L;     $= $+1;  a.$= j;  b.$= H-j+1;  end
             end          /*while $¬==0*/;              return
/*──────────────────────────────────────────────────────────────────────────────────────*/
radix:   procedure expose @.;  parse arg size,w;   mote= c2d(' ');    #= 1;   !.#._n= size
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
selection: procedure expose @.;  parse arg n
              do j=1  for n-1;         _= @.j;         p= j
                  do k=j+1  to n;      if @.k>=_  then iterate
                  _= @.k;              p= k      /*this item is out─of─order, swap later*/
                  end   /*k*/
              if p==j  then iterate              /*if the same, the order of items is OK*/
              _= @.j;     @.j= @.p;    @.p=      /*swap 2 items that're out─of─sequence.*/
              end       /*j*/;         return
/*──────────────────────────────────────────────────────────────────────────────────────*/
shell: procedure expose @.;   parse arg N        /*obtain the  N  from the argument list*/
       i= N % 2                                  /*%   is integer division in REXX.     */
                  do  while i\==0
                         do j=i+1  to N;    k= j;      p= k-i         /*P: previous item*/
                         _= @.j
                                do  while k>=i+1 & @.p>_;   @.k= @.p;    k= k-i;    p= k-i
                                end   /*while k≥i+1*/
                         @.k= _
                         end          /*j*/
                  if i==2  then i= 1
                           else i= i * 5 % 11
                  end                 /*while i¬==0*/;                  return
