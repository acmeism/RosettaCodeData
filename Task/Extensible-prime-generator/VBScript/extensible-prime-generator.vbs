'uses variant booleans for the sieve, so 16 bytes per bit, a little wasteful!

Option Explicit

Sub sieveit(maxi)  'increases sieve size up to maxi and sieves the added part
   Dim lasttop,a,b,c,i,j
   lasttop=UBound(primes)
   If maxi>lasttop Then
   ReDim preserve primes(maxi)
   print vbcrlf &"(sieving from " & lasttop & " up to " & maxi &")"& vbCrLf
   For i=lasttop+1 To maxi
      primes(i)=True
   next
   For i=2 To Int(Sqr(lasttop))
     If primes(i)=True Then
       a=lasttop\i
       b=maxi\i
       c= i*a
       For j=a To b
         primes(c)=False
         c=c+i
       Next
     End if
   Next
   For i=Int(Sqr(lasttop)) To Int(Sqr(maxi))
      If primes(i)=True Then
      c=i*i
      While c<=maxi
        primes(c)=False
        c=c+i
      wend
     End if
   next
   End if
End Sub

function nth(n)  'returns the nth prime (sieves if needed)
   Dim cnt,i,m
   m=Int(n *(Log(n)+Log(Log(n))))

   If m>UBound(primes) Then sieveit (m)
   i=1
   Do
     i=i+1
     If primes(i) Then cnt=cnt+1
   Loop until cnt=n
   nth=i
End function

Sub printprimes (x1, x2,p) ' counts and prints (if p=true) primes between x1 and x2 (sieves if needed)
    Dim lasttop,n,cnt,i
    If x2> UBound(primes) Then sieveit(x2)
    print "primes in range " & x1 & " To " & x2 & vbCrLf
    cnt=0
    For i=x1 To x2
       If primes(i) Then
        If p Then print i & vbTab
        cnt=cnt+1
       End if
    next
    print vbCrLf & "Count: " & cnt
End Sub


Sub print(s):
      On Error Resume Next
      WScript.stdout.WriteLine (s)
      If  err= &h80070006& Then WScript.Echo " Please run this script with CScript": WScript.quit
End Sub



' main program-------------------------------------------
Dim n
' initialization of the array of booleans
reDim Primes(2)
primes(0) = False
Primes(1) = False
Primes(2) = True

'Show the first twenty primes.
n=nth(20)
printprimes 1,n,1

'Show the primes between 100 and 150.
printprimes 100,150,1

'Show the number of primes between 7,700 and 8,000.
printprimes 7700,8000,0

'Show the 10,000th prime.
n= nth(10000)
print n & " is the " & 10000 & "th prime"
