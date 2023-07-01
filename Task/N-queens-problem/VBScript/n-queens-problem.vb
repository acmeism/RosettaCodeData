'N-queens problem - non recursive & structured - vbs - 24/02/2017
const l=15
dim a(),s(),u(): redim a(l),s(l),u(4*l-2)
for i=1 to l: a(i)=i: next
for n=1 to l
    m=0
    i=1
    j=0
    r=2*n-1
    Do
        i=i-1
        j=j+1
        p=0
        q=-r
        Do
            i=i+1
            u(p)=1
            u(q+r)=1
            z=a(j): a(j)=a(i): a(i)=z  'swap a(i),a(j)
            p=i-a(i)+n
            q=i+a(i)-1
            s(i)=j
            j=i+1
        Loop Until j>n Or u(p)<>0 Or u(q+r)<>0
        If u(p)=0 Then
            If u(q+r)=0 Then
                m=m+1  'm: number of solutions
                'x="": for k=1 to n: x=x&" "&a(k): next: msgbox x,,m
             End If
        End If
        j=s(i)
        Do While j>=n And i<>0
            Do
                z=a(j): a(j)=a(i): a(i)=z  'swap a(i),a(j)
                j=j-1
            Loop Until j<i
            i=i-1
            p=i-a(i)+n
            q=i+a(i)-1
            j=s(i)
            u(p)=0
            u(q+r)=0
        Loop
    Loop Until i=0
    wscript.echo n &":"& m
next 'n
