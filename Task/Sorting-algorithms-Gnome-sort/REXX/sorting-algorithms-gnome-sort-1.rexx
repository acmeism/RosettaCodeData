/*REXX program sorts an array using the gnome sort algorithm (elements contain blanks). */
call gen                                         /*generate the  @   stemmed array.     */
call show     'before sort'                      /*display the   before  array elements.*/
                             say copies('▒', 60) /*show a separator line between sorts. */
call gnomeSort  #                                /*invoke the well─known  gnome  sort.  */
call show     ' after sort'                      /*display the    after  array elements.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gen: @.=;  @.1= '---the seven virtues---';    @.4= "Hope"           ;    @.7= 'Justice'
           @.2= '=======================';    @.5= "Charity  [Love]";    @.8= 'Prudence'
           @.3= 'Faith'                  ;    @.6= "Fortitude"      ;    @.9= 'Temperance'
             do #=1  while @.#\==''; end;   #= #-1;   w= length(#);  return /*get #items*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
gnomeSort: procedure expose @.;  parse arg n;     k= 2            /*N: is number items. */
             do j=3  while k<=n;                  p= k - 1        /*P: is previous item.*/
             if @.p<<=@.k  then do;      k= j;    iterate;   end  /*order is OK so far. */
             _= @.p;       @.p= @.k;     @.k= _                   /*swap two @ entries. */
             k= k - 1;     if k==1  then k= j;    else j= j-1     /*test for 1st index. */
             end    /*j*/;                                return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  do j=1  for #;   say '       element'  right(j, w)  arg(1)":"  @.j;   end;   return
