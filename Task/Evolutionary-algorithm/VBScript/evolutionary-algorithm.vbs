Option explicit

Function rand(l,u) rand= Int((u-l+1)*Rnd+l): End Function

Function fitness(i)
  Dim d,j
  d=0
  For j=1 To lmod
     If Mid(model,j,1)=Mid(cpy(i),j,1) Then d=d+1
  Next
fitness=d
End Function

Sub mutate(i)
Dim j
 cpy(i)=""
 For j=1 To lmod
 If Rnd<mut Then
  cpy(i)=cpy(i)& Chr(rand(lb,ub))
 Else
  cpy(i)=cpy(i)& Mid(cpy(0),j,1)
 End If
 Next
End sub

Sub print(s):
   On Error Resume Next
    WScript.stdout.WriteLine (s)
   If  err= &h80070006& Then WScript.Echo " Please run this script with CScript": WScript.quit
End Sub

Dim model,lmod,ub,lb,c,cpy,fit,best,i,d,mut,cnt
model="METHINKS IT IS LIKE A WEASEL"
model=Replace(model," ","@")
lmod=Len(model)
Randomize Timer
ub=Asc("Z")
lb=Asc("@")
c=10
mut=.05
best=0
ReDim cpy(c)


For i=0 To lmod-1
 cpy(best)=cpy(best)& chr(rand(lb,ub))
Next
best=0
cnt=0
do
  cpy(0)=cpy(best)
  fit=0
  For i=1 To c
   mutate(i)
   d=fitness(i)
   If d>fit Then fit=d:best=i
  Next
  cnt=cnt+1
  If (fit=lmod) Or ((cnt mod 10)=0)  Then print cnt &" " & fit & " "& Replace (cpy(best),"@"," ")
Loop While fit <>lmod
