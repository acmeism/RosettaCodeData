/*REXX program performs a type of  bogo sort  on  numbers in an array.  */
parse arg list                         /*obtain optional list from C.L. */
if list=''  then list=-21 333 0 444.4  /*Not defined?  Then use default.*/
#=words(list)                          /*the number of numbers in list. */
   do i=1  for words(list);  @.i=word(list,i);  end   /*create an array.*/
call tell 'before bogo sort'

  do bogo=1

    do j=1  for #-1;   jp=j+1          /* [↓]  compare a # with the next*/
    if @.jp>=@.j  then iterate         /*so far, so good;  keep looking.*/
                                       /*get 2 unique random #s for swap*/
       do  until a\==b;  a=random(1, #);     b=random(1, #);    end

    parse value @.a @.b  with  @.b @.a /*swap 2 random numbers in array.*/
    iterate bogo                       /*go and try another bogo sort.  */
    end     /*j*/

  leave                                /*we're finished with bogo sort. */
  end       /*bogo*/                   /* [↓]  show the # of bogo sorts.*/

say 'number of bogo sorts performed =' bogo
call tell ' after bogo sort'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell:  say;  say center(arg(1), 50, '─')
                 do t=1  for #
                 say arg(1)  'element'right(t, length(#))'='right(@.t, 18)
                 end   /*t*/
say
return
