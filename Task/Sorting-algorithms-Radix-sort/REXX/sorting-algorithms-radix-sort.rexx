/*REXX program performs a   radix sort   on a  stemmed  integer array.  */
aList='0 2 3 4 5 5 7 6 6 7 11 7 13 9 8 8 17 8 19 9 10 13 23 9 10 15 9 11',
      '29 10 31 10 14 19 12 10 37 21 16 11 41 12 43 15 11 25 47 11 14 12',
      '20 17 53 11 16 13 22 31 59 12 61 33 13 12 18 16 67 21 26 14 71 12',
      '73 39 13 23 18 18 79 13 12 43 83 14 22 45 32 17 89 13 20 27 34 49',
      '24 13 97 16 17 14 101 22 103 19 15 55 107 13 109 18 40 15 113 -42'
/*excluding -42, the abbreviated list is called the integer log function*/

mina=word(aList,1);  maxa=mina

     do n=1 for words(aList); x=word(aList,n); @.n=x   /*list ──► array.*/
     mina=min(x,mina);  maxa=max(x,maxa)
     width=max(length(abs(mina)),length(maxa))
     end

n=words(aList);    w=length(n);    call radSort n

         do j=1 for n
         say 'item' right(j,w) "after the radix sort:" right(@.j,width+1)
         end    /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────RADSORT subroutine─────────────────*/
radSort:  procedure expose @. width;  parse arg size;  mote=c2d(' ');  #=1
!.#._b=1
!.#._i=1
!.#._n=size;     do i=1 for size;   y=@.i;   @.i=right(abs(y),width,0)
                 if y<0 then @.i='-'@.i
                 end   /*i*/
/*══════════════════════════════════════where the rubber meets the road.*/
  do while #\==0; ctr.=0; L='ffff'x; low=!.#._b; n=!.#._n; radi=!.#._i; H=
  #=#-1
        do j=low for n;     parse var @.j =(radi) _ +1;      ctr._=ctr._+1
        if ctr._==1 then if _\=='' then do
                                        if _<<L then L=_
                                        if _>>H then H=_
                                        end
        end   /*j*/

  if L>>H then iterate
  _=
  if L==H then if ctr._==0 then do;  #=#+1;   !.#._b=low
                                              !.#._n=n
                                              !.#._i=radi+1;    iterate
                                end

  L=c2d(L);   H=c2d(H);    ?=ctr._+low;     top._=?;    ts=mote;     max=L

               do k=L to H;   _=d2c(k,1);   cen=ctr._
               if cen>ts  then  parse value    cen  k    with    ts  max
               ?=?+cen;   top._=?
               end   /*k*/
  pivot=low

     do while pivot<low+n;  it=@.pivot
          do forever
          parse var it =(radi) _ +1; cen=top._-1; if pivot>=cen then leave
          top._=cen;  ?=@.cen;  @.cen=it;  it=?
          end    /*forever*/
     top._=pivot;  @.pivot=it;  pivot=pivot+ctr._
     end         /*while pivot<low+n*/

  i=max

      do until i==max;   _=d2c(i,1);   i=i+1;   if i>H then i=L;   d=ctr._
      if d<=mote then do; if d>1 then call .radSortP top._,d; iterate; end
      #=#+1;     !.#._b=top._
                 !.#._n=d
                 !.#._i=radi+1
      end   /*until i==max*/
  end       /*while #\==0 */
/*═════════════════════════════════════we're done with the heavy lifting*/

        do i=1 for size;   @.i=@.i+0;   end   /*i*/
return
/*───────────────────────────────────.radSortP subroutine───────────────*/
.radSortP:    parse arg bbb,nnn
          do k=bbb+1 for nnn-1;   q=@.k
              do j=k-1 by -1 to bbb while q<<@.j;  jp=j+1;  @.jp=@.j;  end
          jp=j+1;     @.jp=q
          end   /*k*/
return
