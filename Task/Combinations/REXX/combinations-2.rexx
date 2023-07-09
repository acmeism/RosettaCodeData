/*REXX program displays combination sets for X things taken Y at a time.         */
Parse Arg things size characters
If things='?' Then Do
  Say 'rexx combi2 things size characters'
  Say ' defaults:  5      3    123456789...'
  Say 'example rexx combi2 , , xyzuvw'
  Say 'size<0 shows only the number of possible combinations'
  Exit
  End
If things==''|things=="," Then things=5  /* No things specified? Then use default*/
If size==''  |size==","   Then size=3    /* No size   specified? Then use default*/
Numeric Digits 20
show=sign(size)
size=abs(size)
If things<size Then
  Call exit 'Not enough things ('things') for size ('size').'    Say '----------' things 'things taken' size 'at a time:'
n=2**things-1
nc=0
Do u=1 to n
  nc=nc+combinations(u)
  End
Say '------------' nc 'combinations.'
Exit
combinations: Procedure Expose things size characters show
  Parse Arg u
  nc=0
  bu=x2b(d2x(u))
  bu1=space(translate(bu,' ',0),0)
  If length(bu1)=size Then Do
    ub=reverse(bu)
    res=''
    Do i=1 To things
      If characters<>'' then
        c=substr(characters,i,1)
      Else
        c=i
      If substr(ub,i,1)=1 Then res=res c
      End
    If show=1 then
      Say res
    Return 1
    End
  Else
    Return 0
exit:
  Say '*****error*****' arg(1)
  Exit 13
