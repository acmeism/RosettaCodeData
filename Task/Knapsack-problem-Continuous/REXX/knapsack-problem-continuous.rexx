/*REXX program to solve the burglar's knapsack (continuous) problem.    */
@.=''
/*════ name    weight  value   ════*/
@.1 = 'flitch     4      30   '
@.2 = 'beef       3.8    36   '
@.3 = 'pork       5.4    43   '
@.4 = 'greaves    2.4    45   '
@.5 = 'brawn      2.5    56   '
@.6 = 'welt       3.7    67   '
@.7 = 'ham        3.6    90   '
@.8 = 'salami     3      95   '
@.9 = 'sausage    5.9    98   '

nL=length('total weight');    wL=length('weight');    vL=length(' value ')
totW=0;  totV=0
                      do j=1 while @.j\=='' ;     parse var @.j n w v .
                      nL=max(nL,length(n))  ;     n.j=n
                      totW=totW+w           ;     w.j=w
                      totV=totV+v           ;     v.j=v
                      end   /*j*/
items=j-1                              /*items  is the number of items. */
nL=nL+nL%4                             /*nL:  max length name  +  25%.  */
wL=max(wL,length(format(totw,,2)))     /*wL:  max formatted weight width*/
vL=max(vL,length(format(totv,,2)))     /*vL:  max formatted value  width*/
totW=0;  totV=0
call show 'before sorting'

  do j=2  to items                     /*sort by desending value/unit wt*/
   k=j-1;   _n=n.j;   _w=w.j;   _v=v.j
          do k=k  by -1  to 1  while v.k/w.k < _v/_w
          kp1=k+1;    n.kp1=n.k;    w.kp1=w.k;    v.kp1=v.k
          end   /*k*/
  kp1=k+1;   n.kp1=_n;   w.kp1=_w;   v.kp1=_v
  end   /*j*/

call show 'after sorting'
call hdr "burgler's knapsack contents"
maxW=15                                /*burgler's knapsack max weight. */
             do j=1  for items  while totW < maxW
             if totW+w.j<maxW  then do
                                    totW=totW + w.j
                                    totV=totV + v.j
                                    call syf n.j, w.j, v.j
                                    end
                               else do
                                    f=(maxW-totW) / w.j
                                    totW=totW + w.j*f
                                    totV=totV + v.j*f
                                    call syf n.j, w.j*f, v.j*f
                                    end
             end   /*j*/
call sep
call sy left('total weight',nL,'─'), format(totW,,2)
call sy left('total  value',nL,'─'),                , format(totV,,2)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one─liner subroutines───────────────*/
hdr:   indent=left('',9);  call verse arg(1);  call title;  call sep;    return
sep:   call sy  copies('═',nL), copies("═",wL), copies('═',vL);          return
show:  call hdr arg(1); do j=1 for items; call syf n.j,w.j,v.j;end; say; return
sy:    say indent left(arg(1),nL)   right(arg(2),wL)   right(arg(3),vL); return
syf:   call sy arg(1), format(arg(2),,2), format(arg(3),,2);             return
title: call sy center('item',nL),center("weight",wL),center('value',vL); return
verse: say;     say center(arg(1),50,'─');     say;                      return
