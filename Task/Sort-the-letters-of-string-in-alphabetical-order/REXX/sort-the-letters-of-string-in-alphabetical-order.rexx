/*REXX program sorts an array  (of any kind of items)  using the  bubble─sort algorithm.*/
parse arg y                                      /*generate the array elements  (items).*/
if y=''  then y= "Now is the time for all good men to come to the aid of their country."
             say 'before sort: ───►'y"◄───"      /*show the  before string of characters*/
call make@    y                                  /*convert a string into an array  (@.) */
call bSort    #                                  /*invoke the bubble sort  with # items.*/
call makeS                                       /*convert an array (@.) into a string. */
             say ' after sort: ───►'$"◄───"      /*show the  before string of characters*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
bSort: procedure expose @.;  parse arg n         /*N: is the number of @ array elements.*/
         do m=n-1  by -1  until ok;        ok= 1 /*keep sorting the  @ array until done.*/
           do j=1  for m;  k= j+1;  if @.j<=@.k  then iterate      /*elements in order? */
           _= @.j;  @.j= @.k;  @.k= _;     ok= 0 /*swap two elements;  flag as not done.*/
           end   /*j*/
         end     /*m*/;               return
/*──────────────────────────────────────────────────────────────────────────────────────*/
make@: parse arg z;  #= length(z);    do j=1  for #;  @.j= substr(z, j, 1);  end;   return
makeS: parse arg a;  $=;              do j=1  for #;  $= $  ||  @.j;         end;   return
