ArithmeticNumbers(n, mx:=0){
    c := composite := 0
    loop
    {
        num := A_Index, sum := 0
        x := Factors(num)
        for i, v in x
            sum += v
        av := sum / x.Count()
        if (av = Floor(av))
        {
            res .= c++ <= 100 ? SubStr("  " num, -2) (mod(c, 25) ? " " : "`n") : ""
            composite += x.Count() > 2 ? 1 : 0
        }
        if (c = n) || (c = mx)
            break
    }
    return [n?num:res, composite]
}
Factors(n){
	Loop, % floor(sqrt(n))
		v := A_Index = 1 ? 1 "," n : mod(n,A_Index) ? v : v "," A_Index "," n//A_Index
	Sort, v, N U D,
	Return StrSplit(v, ",")
}
