Dim Shared arr(0 To 1000000) As Ulongint

Sub sievePrimes(limit As Ulongint, primes() As Ulongint)
    Dim As Boolean isPrime()
    Redim isPrime(0 To limit)
    Dim As Ulongint i, j
    For i = 2 To limit
        isPrime(i) = True
    Next
    For i = 2 To Sqr(limit)
        If isPrime(i) Then
            For j = i * i To limit Step i
                isPrime(j) = False
            Next
        End If
    Next
    Dim As Ulongint cnt = 0
    For i = 2 To limit
        If isPrime(i) Then cnt += 1
    Next
    Redim primes(0 To cnt - 1)
    Dim As Ulongint idx = 0
    For i = 2 To limit
        If isPrime(i) Then
            primes(idx) = i
            idx += 1
        End If
    Next
End Sub

Sub QuickSort(arr() As Ulongint, first As Long, last As Long)
    Dim As Long i = first, j = last
    Dim As Ulongint pivot = arr((first + last) \ 2)
    While i <= j
        While arr(i) < pivot : i += 1 : Wend
        While arr(j) > pivot : j -= 1 : Wend
        If i <= j Then
            Swap arr(i), arr(j)
            i += 1
            j -= 1
        End If
    Wend
    If first < j Then QuickSort(arr(), first, j)
    If i < last Then QuickSort(arr(), i, last)
End Sub

Sub generateKpowerful(n As Ulongint, k As Integer, primes() As Ulongint, idx As Integer, current As Ulongint, Byref cnt As Ulongint)
    If current > n Then Exit Sub
    arr(cnt) = current
    cnt += 1
    For i As Integer = idx To Ubound(primes)
        Dim As Ulongint p = primes(i)
        Dim As Ulongint power = p ^ k
        While current <= n \ power
            generateKpowerful(n, k, primes(), i + 1, current * power, cnt)
            If power > n \ p Then Exit While ' Prevent overflow
            power *= p
        Wend
    Next
End Sub

Function countKpowerful(n As Ulongint, k As Integer) As Ulongint
    Dim As Ulongint limit = n ^ (1.0 / k)
    Dim primes() As Ulongint
    sievePrimes(limit, primes())
    Dim As Ulongint cnt = 0
    generateKpowerful(n, k, primes(), 0, 1, cnt)
    If cnt > 1 Then QuickSort(arr(), 0, cnt - 1)
    Dim As Ulongint uniqueCount = 1
    For i As Ulongint = 1 To cnt - 1
        If arr(i) <> arr(i - 1) Then
            arr(uniqueCount) = arr(i)
            uniqueCount += 1
        End If
    Next
    Return uniqueCount
End Function

Dim As Integer i, j, k, kmax
Dim As Ulongint cnt, power
Dim As String sep

' --- BLOCK 1: extremes of k-powers for k=2..10 ---
For k = 2 To 10
    power = 1
    For i = 1 To k
        power *= 10
    Next
    cnt = countKpowerful(power, k)
    Print Using "## "; cnt;
    Print Using "##_-powerful numbers <= 10^& : ["; k; k;

    For i = 0 To 4
        If i < cnt Then Print Using "& "; arr(i);
    Next
    Print Chr(8); "] ... [";

    For i = cnt-5 To cnt-1
        If i >= 0 Then Print arr(i); " ";
    Next
    Print Chr(8); "]"
Next
Print

' --- BLOCK 2: counts for 10^j ---
For k = 2 To 10
    kmax = k+10
    Print Using "Count of ##_-powerful numbers <= 10^j, j in [0, ##): ["; k; kmax;
    For j = 0 To kmax-1
        power = 1
        For i = 1 To j
            power *= 10
        Next
        cnt = countKpowerful(power, k)
        Print cnt;
        If j < kmax-1 Then Print " ";
    Next
    Print "]"
Next

Sleep
