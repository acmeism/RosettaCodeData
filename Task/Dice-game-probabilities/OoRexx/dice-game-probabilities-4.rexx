oid='diet.xxx'; Call sysFileDelete oid
Call test '9  4 6 6'
Call test '5 10 6 7'
Exit
test:
Parse Arg n1 s1 n2 s2
Call o 'Player 1:' n1 'dice with' s1 'sides each'
Call o 'Player 2:' n2 'dice with' s2 'sides each'
cnt1.=0
cnt2.=0
win.=0
nn=10000000
Call time 'R'
Do i=1 To nn
  sum1=sum(n1 s1) ; cnt1.sum1+=1
  sum2=sum(n2 s2) ; cnt2.sum2+=1
  Select
    When sum1>sum2 Then win.1+=1
    When sum1<sum2 Then win.2+=1
    Otherwise           win.0+=1
    End
  End
Call o win.1/nn 'player 1 wins'
Call o win.2/nn 'player 2 wins'
Call o win.0/nn 'draws'
/*
Do i=min(n1,n2) To max(n1*s1,n2*s2)
  Call o right(i,2) format(cnt1.i,7) format(cnt2.i,7)
  End
*/
Call o time('E') 'seconds elapsed'
Return

sum: Parse Arg n s
sum=0
Do k=1 To n
  sum+=rand(s)
  End
Return sum

rand: Parse Arg n
 Return random(n-1)+1

o:
Say arg(1)
Return lineout(oid,arg(1))
