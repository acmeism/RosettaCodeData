a=.my_array~new(20)
do i=1 To 20
  a[i]=i
  End
s=a~makestring((LINE),',')
Say s
Say '    sum='a~sum
Say 'product='a~prod
::class my_array subclass array
::method sum
sum=0
Do i=1 To self~dimension(1)
  sum+=self[i]
  End
Return sum
::method prod
Numeric Digits 30
prod=1
Do i=1 To self~dimension(1)
  prod*=self[i]
  End
Return prod
