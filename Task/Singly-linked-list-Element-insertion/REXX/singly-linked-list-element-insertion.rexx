/*REXX program demonstrates how to create and show a single-linked list.*/
@.=0                                   /*define a null linked list.     */
call set@ 3                            /*linked list:  12 Proth primes. */
call set@ 5
call set@ 13
call set@ 17
call set@ 41
call set@ 97
call set@ 113
call set@ 193
call set@ 241
call set@ 257
call set@ 353
call set@ 449
call list@
     after = 97                        /* ◄──── REXX code to do insert. */
     newVal=100                        /* ◄────   "    "   "  "    "    */
     #=@..after                        /* ◄────   "    "   "  "    "    */
     call ins@ #,newVal                /* ◄────   "    "   "  "    "    */
say
say 'a new value of' newval "has been inserted after element value:" after
call list@
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────INS@ subroutine─────────────────────*/
ins@:  procedure expose @.;  parse arg #,y
@._last=@._last+1                      /*bump number of list elements.  */
_=@._last
@._._value=y                           /*define new value list element. */
@._._next=@.#._next
@.#._next=_
@..y=_                                 /*set a locator pointer to self. */
@.max_width=max(@.max_width,length(y)) /*set maximum width of any value.*/
return                                 /*return to invoker of this sub. */
/*──────────────────────────────────LIST@ subroutine────────────────────*/
list@: say;  w=max(7, @.max_width )    /*use the max width of nums or 7.*/
say center('item',6)        center('value',w)        center('next',6)
say center(''    ,6,'─')    center(''     ,w,'─')    center(''    ,6,'─')
p=1
        do j=1  until p==0      /*show all entries of linked list*/
        say  right(j,6)   right(@.p._value,w)   right(@.p._next,6)
        p=@.p._next
        end   /*j*/
return
/*──────────────────────────────────SET@ subroutine─────────────────────*/
set@: procedure expose @.; parse arg y /*get element to be added to list*/
_=@._last                              /*set the previous last element. */
n=_+1                                  /*bump last ptr in linked list.  */
@._._next=n                            /*set the  next  pointer value.  */
@._last=n                              /*define next item in linked list*/
@.n._value=y                           /*set item to the value specified*/
@.n._next=0                            /*set the  next  pointer value.  */
@..y=n                                 /*set a locator pointer to self. */
@.max_width=max(@.max_width,length(y)) /*set maximum width of any value.*/
return                                 /*return to invoker of this sub. */
