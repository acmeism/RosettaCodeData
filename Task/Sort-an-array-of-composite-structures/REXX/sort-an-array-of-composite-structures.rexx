/*REXX program  sorts an array of composite structures  (which has two classes of data).*/
#=0                                              /*number elements in structure (so far)*/
name='tan'   ;  value= 0;  call add name,value   /*tan    peanut M&M's are  0%  of total*/
name='orange';  value=10;  call add name,value   /*orange    "    "     "  10%   "   "  */
name='yellow';  value=20;  call add name,value   /*yellow    "    "     "  20%   "   "  */
name='green' ;  value=20;  call add name,value   /*green     "    "     "  20%   "   "  */
name='red'   ;  value=20;  call add name,value   /*red       "    "     "  20%   "   "  */
name='brown' ;  value=30;  call add name,value   /*brown     "    "     "  30%   "   "  */
call show  'before sort',  #
say  copies('▒', 70)
call xSort                 #
call show  ' after sort',  #
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
add:   procedure expose # @.;   #=#+1            /*bump the number of structure entries.*/
       @.#.color=arg(1);      @.#.pc=arg(2)      /*construct a entry of the structure.  */
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  procedure expose @.;   do j=1  for arg(2) /*2nd arg≡number of structure elements.*/
                              say right(arg(1),30)  right(@.j.color,9)  right(@.j.pc,4)'%'
                              end   /*j*/        /* [↑]  display  what,  name,  value.  */
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
xSort: procedure expose @.; parse arg N;    h=N
                              do while h>1;                       h=h%2
                                do i=1  for N-h;        j=i;      k=h+i
                                  do  while @.k.color<@.j.color         /*swap elements.*/
                                  _=@.j.color;        @.j.color=@.k.color;     @.k.color=_
                                  _=@.j.pc;           @.j.pc   =@.k.pc;        @.k.pc   =_
                                  if h>=j  then leave;    j=j-h;    k=k-h
                                  end   /*while @.k.color ···*/
                                end     /*i*/
                              end       /*while h>1*/
       return
