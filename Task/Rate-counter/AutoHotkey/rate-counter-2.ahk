SetBatchLines, -1
QPX(1)  ; start timer
Loop, 1000000 {
    Random, x, 1, 1000000
    Random, y, 1, 1000000
    gcd(x, y)
}
t := QPX(0) ; end timer
MsgBox, % t " Seconds elapsed.`n" Round(1 / (t / 1000000), 0) " Loop iterations per second."

QPX( N=0 ) { ; Wrapper for QueryPerformanceCounter()by SKAN | CD: 06/Dec/2009
    Static F,A,Q,P,X ; www.autohotkey.com/forum/viewtopic.php?t=52083 | LM: 10/Dec/2009
    If  ( N && !P )
        Return  DllCall("QueryPerformanceFrequency",Int64P,F) + (X:=A:=0) + DllCall("QueryPerformanceCounter",Int64P,P)
    DllCall("QueryPerformanceCounter",Int64P,Q), A:=A+Q-P, P:=Q, X:=X+1
    Return  ( N && X=N ) ? (X:=X-1)<<64 : ( N=0 && (R:=A/X/F) ) ? ( R + (A:=P:=X:=0) ) : 1
}

gcd(a, b) {    ; Euclidean GCD
    while b
        t := b, b := Mod(a, b), a := t
    return, a
}
