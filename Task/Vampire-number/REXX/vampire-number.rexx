/*REXX pgm displays  X  vampire numbers, or verifies if a # is vampiric.*/
numeric digits 20                      /*be able to handle large numbers*/
parse arg N .;   if N==''  then N=25   /*No arg?  Then use the default. */
#=0                                    /*number of vampire numbers found*/
if N>0 then do j=1260  until  # >= N   /*search until N vampire #s found*/
            if length(j)//2  then do;  j=j*10-1; iterate; end /*adjust J*/
            if n<11453481 then if right(j,1)==1 then iterate  /*tenable?*/
            f=vampire(j)               /*get possible fangs for  J.     */
            if f==''  then iterate     /*Is 2nd fang null? Yes, not vamp*/
            #=#+1                      /*bump the vampire count, Vlad.  */
            say 'vampire number' right(#,length(N)) "is: " j',  fangs=' f
            end   /*j*/
       else do
            f=vampire(-N)              /*get possible fangs for  abs(N).*/
            if f==''  then say   -N    " isn't a vampire number."
                      else say   -N    " is a vampire number, fangs="  f
            end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────VAMPIRE subroutine──────────────────*/
vampire: procedure;        parse arg ?;            L=length(?);      W=L%2
if L//2  then return ''                /*Odd length?   Then not vampire.*/
$.=                                    /*used to build BOT and TOP value*/
fangs=;  do k=1  for L;    _=substr(?,k,1);    $._=$._ || _;    end  /*k*/
bot=;    do m=0  for 10;   bot=bot || $.m;                      end  /*m*/

top=left(reverse(bot),w);  bot=left(bot,w)  /*determine limits of search*/

             do d=max(bot, 10**(w-1))  to  min(top, 10**w-1)
             if ?//d\==0           then iterate
             if verify(d,?)\==0    then iterate
             if ?//d\==0           then iterate
             if verify(d,?)\==0    then iterate
             q=?%d;    if d>q      then iterate
             if q*d//9\==(q+d)//9  then iterate   /*modulo 9 congruence.*/
             if length(q)\==w      then iterate
             if verify(q,?)\==0    then iterate
             if right(q,1)==0      then if right(d,1)==0  then iterate
             dq=d || q;  t=?
                                do i=1  for  L;   p=pos(substr(dq,i,1), t)
                                if p==0  then iterate d
                                t=delstr(t,p,1)
                                end   /*i*/
             fangs=fangs  d','q
             end   /*d*/
return fangs
