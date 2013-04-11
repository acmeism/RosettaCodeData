/*REXX pgm displays  X  vampire numbers, or verifies if a # is vampiric.*/
numeric digits 20                      /*be able to handle large numbers*/
parse arg N .;   if N==''  then N=25   /*No arg?  Then use the default. */
#=0                                    /*number of vampire numbers found*/
if N>0  then do j=1000  until  # >= N  /*search until N vampire #s found*/
             v=vampire(j)
             if words(v)<=1  then iterate
             parse var v v f
             #=#+1
             say 'vampire number' right(#,length(N)) "is: " v',  fangs=' f
             end   /*j*/
if N<0  then do
             parse value vampire(-N)  with  v f
             if v==''  then say   -N   "isn't a vampire number."
                       else say   -N   "is a vampire number, fangs="  f
             end
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────VAMPIRE subroutine──────────────────*/
vampire: procedure expose !.;  parse arg ? 1 z 1 $;   L=length(?);   W=L%2
if L//2  then return ''                /*Odd length?  Then not vampire. */
$.=                                    /*used to build BOT and TOP value*/
       do k=1  for length(?);  _=substr(?,k,1);  $._=$._ || _;   end /*k*/
bot=;  do m=0  for 10;         bot=bot || $.m;                   end /*m*/

top=left(reverse(bot),w);  bot=left(bot,w)  /*determine limits of search*/

           do d=max(bot, 10**(w-1))  to  min(top, 10**w-1)
           if verify(d,?)\==0    then iterate
           if ?//d\==0           then iterate
           q=?%d;    if d>q      then iterate
           if q*d//9\==(q+d)//9  then iterate     /*modulo 9 congruence.*/
           if verify(q,?)\==0    then iterate
           if length(q)\==w      then iterate
           if right(q,1)==0      then if right(d,1)==0  then iterate
           dq=d||q;  t=z
                          do i=1  for  L;   _=substr(dq,i,1);   p=pos(_,t)
                          if p==0  then iterate d
                          t=delstr(t,p,1)
                          end   /*i*/
           $=$ d','q
           end   /*d*/
return $
