/*REXX program demonstrates how to create a single-linked list       */
/* and how to insert an element                                      */
  z.=0                              /* define a null linked z.       */
  Call set_list 3                   /* linked list:  12 Proth primes */
  Call set_list 5 /*see https://mathworld.wolfram.com/ProthPrime.html*/
  Call set_list 13
  Call set_list 17
  Call set_list 41
  Call set_list 97
  Call set_list 113
  Call set_list 193
  Call set_list 241
  Call set_list 257
  Call set_list 353
  Call set_list 449
  Call show_list
  newval=100                    /* Insert this value                 */
  after=97                      /* after the element with this value */
  nnn=z..after                  /* position of z´this value          */
  Call ins_list nnn,newval       /* perform the insertion             */
  Say ''
  Say 'a new value of' newval 'has been inserted',
                         'after element having the value:' after
  Call show_list
  Exit                              /* stick a fork in it, we're done.*/

set_list: Procedure Expose z.
  Parse Arg value                    /* get element to be added to list*/
  last=z.0                           /* set the previous last element. */
  new=z.0+1                          /* set the new ast element.       */
  z.0=new                            /* define next item in linked list*/
  z.last.0next=new                   /* set the  next  pointer value.  */
  z.new.0value=value                 /* set item to the value specified*/
  z.new.0next=0                      /* set the  next  pointer value.  */
  z..value=new                       /* set a locator pointer to self. */
  z.0width=max(z.0width,length(value)) /*set maximum width of any value*/
  Return

ins_list: Procedure Expose z.
  Parse Arg nnn,value
  z.0=z.0+1                          /* bump number of list elements.  */
  last=z.0                           /* position of the new value      */
  z.last.0value=value                /* store the new value            */
  z.last.0next=z.nnn.0next           /* uptate the pointers to the     */
  z.nnn.0next=last                   /* next element                   */
  z..value=last                      /* store position of the new value*/
  z.0width=max(z.0width,length(value)) /*set maximum width of any value*/
  Return

show_list:
  Say
  w=max(7,z.0width)                    /* use the max width of nums or 7.*/
  Say center('item',6) 'position' center('value',w) center('next',6)
  Say center('',6,'-') '--------' center('',w,'-') center('',6,'-')
  p=1
  Do j=1 Until p==0                 /* show all entries of linked list*/
    Say right(j,6) right(p,8) right(z.p.0value,w) right(z.p.0next,6)
    p=z.p.0next
    End                             /* j                              */
  Return
