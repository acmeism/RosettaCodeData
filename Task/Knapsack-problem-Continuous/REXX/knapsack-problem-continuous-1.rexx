/*REXX program solves the  (continuous)   burglar's knapsack   problem. */
@.=                     /*═══════  name    weight  value  ══════*/
                           @.1 = 'flitch     4       30   '
                           @.2 = 'beef       3.8     36   '
                           @.3 = 'pork       5.4     43   '
                           @.4 = 'greaves    2.4     45   '
                           @.5 = 'brawn      2.5     56   '
                           @.6 = 'welt       3.7     67   '
                           @.7 = 'ham        3.6     90   '
                           @.8 = 'salami     3       95   '
                           @.9 = 'sausage    5.9     98   '
parse arg maxW d .                     /*get possible args from the C.L.*/
if maxW=='' | maxW==','  then maxW=15  /*burglar's knapsack max weight. */
if    d=='' |    d==','  then    d= 3  /*# of decimal digits in FORMAT. */
wL=d+length('weight');  nL=d+length('total weight');  vL=d+length('value')
totW=0;  totV=0
                do #=1  while @.#\=='';   parse var @.# n.# w.# v.# .
                end   /*#*/            /* [↑]  assign to separate lists.*/
#=#-1                                  /*#:   number of items in @ list.*/
call show  'unsorted item list'        /*display header and the  @ list.*/
call sortD                             /*invoke using a descending sort.*/
call hdr "burglar's knapsack contents"
                do j=1  for #      while totW<maxW;   f=1   /*grab items*/
                if totW+w.j>=maxW  then f=(maxW-totW)/w.j   /*calc fract*/
                totW=totW+w.j*f;        totV=totV+v.j*f     /*add──►tots*/
                call syf left(word('{all}',1+(f\==1)),5) n.j, w.j*f, v.j*f
                end   /*j*/                                 /*↑show item*/
call sep; say                          /* [↓]   $ supresses trailing Θs.*/
call sy left('total weight',nL,'─'),       $(format(totW,,d))
call sy left('total  value',nL,'─'),    ,  $(format(totV,,d))
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────one─liner subroutines──────────────────────*/
hdr:   say; say;  say center(arg(1),50,'─');  say;  call title; call sep;  return
sep:   call sy  copies('═',nL), copies("═",wL), copies('═',vL);            return
show:  call hdr arg(1);   do j=1  for #;  call syf n.j,w.j,v.j;  end;      return
sy:    say left('',9) left(arg(1),nL) right(arg(2),wL) right(arg(3),vL);   return
syf:   call sy arg(1), $(format(arg(2),,d)), $(format(arg(3),,d));         return
title: call sy center('item',nL), center("weight",wL), center('value',vL); return
$:x=arg(1);if pos(.,x)>1 then x=left(strip(strip(x,'T',0),,.),length(x));return x
/*──────────────────────────────────SORTD subroutine───────────────────────────*/
sortD: do sort=2 to #; _n=n.sort;   _w=w.sort;      _v=v.sort    /*descending. */
          do k=sort-1  by -1  to 1   while  v.k/w.k<_v/_w        /*order items.*/
          p=k+1;        n.p=n.k;     w.p=w.k;        v.p=v.k     /*shuffle 'em.*/
          end   /*k*/                                            /*[↓] last one*/
       a=k+1;           n.a=_n;      w.a=_w;         v.a=_v      /*place item. */
       end      /*sort*/
return                         /*  ↑ ↑ ↑   algorithm is OK for smallish arrays.*/
