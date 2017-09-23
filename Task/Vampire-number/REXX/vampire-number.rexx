/*REXX program displays  N  vampire numbers,  or  verifies  if  a number is vampiric.   */
numeric digits 20                                /*be able to handle gihugic numbers.   */
parse arg N .;   if N=='' | N==","  then N=25    /*Not specified?  Then use the default.*/
!.0=1260;   !.1=11453481;   !.2=115672;   !.3=124483;   !.4=105264      /*lowest #, dig.*/
!.5=1395;   !.6=126846;     !.7=1827;     !.8=110758;   !.9=156289      /*   "   "   "  */
#=0                                              /*num. of vampire numbers found, so far*/
if N>0 then do j=1260  until  # >= N             /*search until N vampire numbers found.*/
            if length(j) // 2  then do;   j=j*10 - 1;    iterate;     end  /*adjust J*/
            _=right(J,1); if j<!._  then iterate /*is number tenable based on last dig? */
            f=vampire(j); if f==''  then iterate /*Are fangs null?   Yes, not vampire.  */
            #=#+1                                /*bump the vampire count, Vlad.        */
            say 'vampire number' right(#,length(N)) "is: " j',  fangs=' f
            end   /*j*/                          /* [↑]  process a range of numbers.    */
       else do;  N=abs(N);       f=vampire(N)    /* [↓]  process one number;  get fangs.*/
            if f==''  then say    N    " isn't a vampire number."
                      else say    N    " is a vampire number, fangs="   f
             end
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
vampire: procedure;  parse arg ?,, $. !! bot;    L=length(?);      if L//2  then return !!
         w=L%2                                   /* [↑]  L an odd length?  Then ¬vampire*/
                        do k=1  for L;    _=substr(?,k,1);    $._=$._ || _;     end  /*k*/
                        do m=0  for 10;   bot=bot || $.m;                       end  /*m*/
         top=left( reverse(bot), w);      bot=left(bot, w)  /*determine limits of search*/
         inc=?//2 + 1                                       /*? is odd? INC=2. No? INC=1*/
         start=max(bot, 10**(w-1));     if inc=2  then if  start//2==0  then start=start+1
                                                            /* [↑]  odd START if odd INC*/
                    do d=start  to  min(top, 10**w-1)  by inc
                    if ?//d\==0           then iterate
                    if verify(d, ?) \==0  then iterate
                    q=?%d;       if d>q   then iterate
                    if q*d//9\==(q+d)//9  then iterate      /*modulo 9 congruence test. */
                    if verify(q, ?) \==0  then iterate
                    if right(q, 1)   ==0  then if right(d, 1)==0  then iterate
                    if length(q)\==w      then iterate
                    dq=d || q;   t=?
                                          do i=1  for  L;      p=pos( substr(dq, i, 1), t)
                                          if p==0  then iterate d;       t=delstr(t, p, 1)
                                          end   /*i*/
                    !!=!!  '['d"∙"q']'
                    end   /*d*/
         return !!
