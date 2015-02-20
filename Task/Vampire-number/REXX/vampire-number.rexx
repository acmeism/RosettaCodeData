/*REXX pgm displays  N  vampire numbers, or verifies if a # is vampiric.*/
numeric digits 20                      /*be able to handle large numbers*/
parse arg N .;   if N==''  then N=25   /*No arg?  Then use the default. */
!.0=1260; !.1=11453481; !.2=115672; !.3=124483; !.4=105264 /*lowest#,dig*/
!.5=1395; !.6=126846;   !.7=1827;   !.8=110758; !.9=156289 /*lowest#,dig*/
#=0                                    /*number of vampire numbers found*/
if N>0  then do j=1260  until  # >= N  /*search until N vampire #s found*/
             if length(j)//2  then do; j=j*10-1; iterate; end /*adjust J*/
             _=right(j,1)              /*obtain the right-most  J digit.*/
             if j<!._  then iterate    /*is # tenable based on last dig?*/
             f=vampire(j)              /*get possible fangs for  J.     */
             if f==''  then iterate    /*Are fangs null?  Yes, ¬vampire.*/
             #=#+1                     /*bump the vampire count, Vlad.  */
             say 'vampire number' right(#,length(N)) "is: " j',  fangs=' f
             end   /*j*/               /* [↑]  process range of numbers.*/
        else do; N=abs(N)              /* [↓]  process a particular num.*/
             f=vampire(N)              /*get possible fangs for  abs(N).*/
             if f==''  then say    N    " isn't a vampire number."
                       else say    N    " is a vampire number, fangs="   f
             end
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────VAMPIRE subroutine──────────────────*/
vampire: procedure;  parse arg ?,,$. !!;   L=length(?);         w=L%2
if L//2  then return !!                /*Odd length?   Then not vampire.*/
         do k=1  for L;    _=substr(?,k,1);    $._=$._ || _;    end  /*k*/
bot=;    do m=0  for 10;   bot=bot || $.m;                      end  /*m*/
top=left(reverse(bot),w);  bot=left(bot,w)  /*determine limits of search*/
if ?//2  then inc=2                         /*if ? is odd, set INC to 2.*/
         else inc=1                         /*··otherwise, set INC to 1.*/
start=max(bot,10**(w-1));  if inc=2 then if start//2==0 then start=start+1
                                            /* [↑]  odd START if odd INC*/
           do d=start  to  min(top, 10**w-1)  by inc
           if ?//d\==0           then iterate
           if verify(d,?)\==0    then iterate
           q=?%d;    if d>q      then iterate
           if q*d//9\==(q+d)//9  then iterate   /*modulo 9 congruence.*/
           if verify(q,?)\==0    then iterate
           if right(q,1)==0      then if right(d,1)==0  then iterate
           if length(q)\==w      then iterate
           dq=d || q;  t=?
                              do i=1  for  L;     p=pos(substr(dq,i,1), t)
                              if p==0  then iterate d;     t=delstr(t,p,1)
                              end   /*i*/
           !!=!!  '['d"∙"q']'
           end   /*d*/
return !!
