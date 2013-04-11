/*REXX program to show how to create and show a single-linked list.     */
@.=0                             /*define a null linked list (so far).  */
call set@ ,3                     /*build linked list of 12 proth primes.*/
call set@ ,5
call set@ ,13
call set@ ,17
call set@ ,41
call set@ ,97
call set@ ,113
call set@ ,193
call set@ ,241
call set@ ,257
call set@ ,353
call set@ ,449
w=length(@._last)                 /*use width of the last item number.  */

      do j=1  for @._last         /*show all entries of the linked list.*/
      say  "item"   right(j,w)  '='  right(@.j._value,@.max_width)
      end   /*j*/
exit                              /*stick a fork in it, we're done.     */
/*───────────────────────────────SET@ subroutine────────────────────────*/
set@:  procedure expose @.;     parse arg #,y
if arg(1,'o') then do             /*if 1st arg omitted, then add to list*/
                   _=@._last+1    /*bump the last ptr in the linked list*/
                   @._last=_      /*define the next item in linked list.*/
                   #=_            /*point   to this item in linked list.*/
                   end
@.#._value=y                      /*set the item to the value specified.*/
@.max_width=max(@.max_width,length(y)) /*set maximum width of any value.*/
if #\==1 then do                  /*if not the first item, link it.     */
              prev=#-1            /*figure out what the previous item is*/
              @.prev._next=#      /*now, link the previous item to here.*/
              end
return                            /*return to the invoker of this sub.  *//
