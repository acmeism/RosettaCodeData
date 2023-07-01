SetBatchLines, -1
fib := NStepSequence(1, 1, 2, 1000)
Out := "Digit`tExpected`tObserved`tDeviation`n"
n := []
for k, v in fib
	d := SubStr(v, 1, 1)
	, n[d] := n[d] ? n[d] + 1 : 1
for k, v in n
	Exppected := 100 * Log(1+ (1 / k))
	, Observed := (v / fib.MaxIndex()) * 100
	, Out .= k "`t" Exppected "`t" Observed "`t" Abs(Exppected - Observed) "`n"
MsgBox, % Out

NStepSequence(v1, v2, n, k) {
	a := [v1, v2]
	Loop, % k - 2 {
		a[j := A_Index + 2] := 0
		Loop, % j < n + 2 ? j - 1 : n
			a[j] := BigAdd(a[j - A_Index], a[j])
	}
	return, a
}

BigAdd(a, b) {
	if (StrLen(b) > StrLen(a))
		t := a, a := b, b := t
	LenA := StrLen(a) + 1, LenB := StrLen(B) + 1, Carry := 0
	Loop, % LenB - 1
		Sum := SubStr(a, LenA - A_Index, 1) + SubStr(B, LenB - A_Index, 1) + Carry
		, Carry := Sum // 10
		, Result := Mod(Sum, 10) . Result
	Loop, % I := LenA - LenB {
		if (!Carry) {
			Result := SubStr(a, 1, I) . Result
			break
		}
		Sum := SubStr(a, I, 1) + Carry
		, Carry := Sum // 10
		, Result := Mod(Sum, 10) . Result
		, I--
	}
	return, (Carry ? Carry : "") . Result
}
