/*REXX program displays combination sets for X things taken Y at a time.         */
Parse Arg things size chars .  /* get optional arguments from the command line   */
If things='?' Then Do
  Say 'rexx combi things size characters'
  Say ' defaults: 5      3    123456789...'
  Say 'example rexx combi , , xyzuvw'
  Say 'size<0 shows only the number of possible combinations'
  Exit
  End
If things==''|things=="," Then things=5  /* No things specified? Then use default*/
If size==''  |size==","   Then size=3    /* No size   specified? Then use default*/
If chars==''|chars=="," Then             /* No chars  specified? Then Use default*/
  chars='123456789abcdefghijklmnopqrstuvwxyz'||,
                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'||,
  "~!@#chars%^&*()_+`{}|[]\:;<>?,./¦++++±==˜·" /*some extended chars             */

show_details=sign(size)                  /* -1: Don't show details               */
size=abs(size)
If things<size Then
  Call exit 'Not enough things ('things') for size ('size').'
Say '------------' things 'things taken' size 'times at a time:'
Say '------------' combn(things,size) 'combinations.'
Exit                                           /* stick a fork in it,  we're all */
/*-------------------------------------------------------------------------------*/
combn: Procedure Expose chars show_details
  Parse Arg things,size
  thingsp=things+1
  thingsm=thingsp-size
  index.=0
  If things=0|size=0 Then
    Return 'no'
  Do i=1 For size
    index.i=i
    End
  done=0
  Do combi=1 By 1 Until done
    combination=''
    Do d=1 To size
      combination=combination substr(chars,index.d,1)
      End
    If show_details=1 Then
      Say combination
    index.size=index.size+1
    If index.size==thingsp Then
      done=.combn(size-1)
    End
  Return combi
/*---------------------------------------------------------------------------------*/
.combn: Procedure Expose index. size thingsm
  Parse Arg d
--Say '.combn' d thingsm show()
  If d==0 Then
    Return 1
  p=index.d
  Do u=d To size
    index.u=p+1
    If index.u==thingsm+u Then
      Return .combn(u-1)
    p=index.u
    End
  Return 0

show:
  list=''
  Do k=1 To size
    list=list index.k
    End
  Return list

exit:
  Say '*****error*****' arg(1)
  Exit 13
