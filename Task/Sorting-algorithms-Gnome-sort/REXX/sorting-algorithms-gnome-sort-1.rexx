/*REXX program sorts a  stemmed array  using the  gnome-sort  algorithm.*/
call  gen@                             /*generate the @. array elements.*/
call  show@      'before sort'         /*show  "before"  array elements.*/
call  gnomeSort   #                    /*invoke the infamous gnome sort.*/
call  show@      ' after sort'         /*show  "after"   array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GNOMESORT subroutine────────────────*/
gnomeSort: procedure expose @.;  parse arg n;   k=2       /*n=num items.*/
        do j=3  while k<=n;                     km=k-1    /*KM=prev item*/
        if @.km<<=@.k  then do;  k=j;  iterate;  end      /*OK so far···*/
        _=@.km;  @.km=@.k;  @.k=_      /*swap 2 entries in the @. array.*/
        k=k-1;   if k==1  then k=j;  else j=j-1           /*test index 1*/
        end    /*j*/                   /* [↑]   perform gnome sort on @.*/
return
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@: !=... 'deadbeef'x ...;    @.=!   /*default none-value; allows null*/
@.1 = '---the seven virtues---'        /* [↓]  indent the seven virtues.*/
@.2 = '=======================' ;             @.6 = 'Fortitude'
@.3 = 'Faith'                   ;             @.7 = 'Justice'
@.4 = 'Hope'                    ;             @.8 = 'Prudence'
@.5 = 'Charity  [Love]'         ;             @.9 = 'Temperance'

           do #=1  while @.#\==!; end  /*find the # of items in @ array.*/
#=#-1                                  /*adjust the numer of items by 1.*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@:             do j=1  for #       /* [↓]  display all items for @. */
                   say '      element'  right(j,length(#))  arg(1)":"  @.j
                   end   /*j*/         /* [↑]   right justify the J num.*/
say copies('■',60)                     /*show a separator line that fits*/
return
