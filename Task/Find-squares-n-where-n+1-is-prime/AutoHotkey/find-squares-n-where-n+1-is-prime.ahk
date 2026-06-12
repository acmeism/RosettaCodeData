n := 0
while ((n2 := (n+=2)**2) < 1000)
    if isPrime(n2+1)
        result .= (result ? ", ":"" ) n2
MsgBox % result := 1 ", " result
return

isPrime(n, i:=2){
    while (i < Sqrt(n)+1)
        if !Mod(n, i++)
            return False
    return True
}
