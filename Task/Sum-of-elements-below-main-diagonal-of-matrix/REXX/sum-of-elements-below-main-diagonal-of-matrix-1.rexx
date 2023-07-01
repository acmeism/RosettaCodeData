/* REXX */
ml ='1 3 7 8 10 2 4 16 14 4 3 1 9 18 11 12 14 17 18 20 7 1 3 9 5'
Do i=1 To 5
  Do j=1 To 5
    Parse Var ml m.i.j ml
    End
  End

l=''
Do i=1 To 5
  Do j=1 To 5
    l=l right(m.i.j,2)
    End
  Say l
  l=''
  End

sum=0
Do i=2 To 5
  Do j=1 To i-1
    sum=sum+m.i.j
    End
  End
Say 'Sum below main diagonal:' sum
