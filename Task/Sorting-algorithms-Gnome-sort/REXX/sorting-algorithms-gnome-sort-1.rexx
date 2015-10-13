/*REXX program sorts a  stemmed array  using the  gnome sort  algorithm.      */
call  gen;          w=length(#)        /*generate @ array;   W  is width of #.*/
call  show         'before sort'       /*display the  "before" array elements.*/
say copies('▒',60)                     /*show a separator line between sorts. */
call  gnomeSort    #                   /*invoke the well─known  gnome  sort.  */
call  show         ' after sort'       /*display the   "after" array elements.*/
exit                                   /*stick a fork in it,  we're all done. */
/*──────────────────────────────────GNOMESORT subroutine──────────────────────*/
gnomeSort: procedure expose @.;  parse arg n;   k=2      /*N: is number items.*/
        do j=3  while k<=n;                     p=k-1    /*P: is previous item*/
        if @.p<<=@.k  then do;  k=j;  iterate;  end      /*array is OK so far.*/
        _=@.p;  @.p=@.k;  @.k=_                          /*swap two @ entries.*/
        k=k-1;   if k==1  then k=j;  else j=j-1          /*test for 1st index.*/
        end    /*j*/
return
/*──────────────────────────────────GEN subroutine────────────────────────────*/
gen: @.=;    @.1 = '---the seven virtues---' ;           @.5 = 'Charity  [Love]'
             @.2 = '=======================' ;           @.6 = 'Fortitude'
             @.3 = 'Faith'                   ;           @.7 = 'Justice'
             @.4 = 'Hope'                    ;           @.8 = 'Prudence'
                                                         @.9 = 'Temperance'
  do #=1  while @.#\==''; end;   #=#-1 /*determine number of items in @ array.*/
return
/*──────────────────────────────────SHOW subroutine───────────────────────────*/
show: do j=1  for #; say '      element' right(j,w) arg(1)":" @.j; end;   return
