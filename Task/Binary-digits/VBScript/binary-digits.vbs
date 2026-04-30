Option Explicit
Dim bin
bin=Array("    ","   I","  I ","  II"," I  "," I I"," II "," III","I   ","I  I","I I ","I II"," I  ","II I","III ","IIII")

Function num2bin(n)
 Dim s,i,n1,n2
 s=Hex(n)
 For i=1 To Len(s)
   n1=Asc(Mid(s,i,1))
   If n1>64 Then n2=n1-55 Else n2=n1-48
   num2bin=num2bin & bin(n2)
 Next
 num2bin=Replace(Replace(LTrim(num2bin)," ","0"),"I",1)
 End Function

 Sub print(s):
     On Error Resume Next
     WScript.stdout.WriteLine (s)
     If  err= &h80070006& Then WScript.Echo " Please run this script with CScript": WScript.quit
 End Sub
 print num2bin(5)
 print num2bin(50)
 print num2bin(9000)
