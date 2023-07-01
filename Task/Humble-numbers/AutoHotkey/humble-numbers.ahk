n := 1, c := 0
while (c < 50)
{
    if isHumbleNumbers(prime_numbers(n))
        c++, result .= n " "
    n++
}

n := 1, l := 0, c:=[]
loop
{
    if (l:=StrLen(n)) > 5
        break
    if isHumbleNumbers(prime_numbers(n))
        c[l] := c[l] ? c[l] + 1 : 1
    n++
}
for i, v in c
    result .= "`n" i ":`t" v

MsgBox, 262144, ,% result
return

isHumbleNumbers(x){
    for i, v in x
        if v > 7
            return false
    return true
}

prime_numbers(n) {
    if (n <= 3)
        return [n]
    ans := [], done := false
    while !done {
        if !Mod(n,2)
            ans.push(2), n/=2
        else if !Mod(n,3)
            ans.push(3), n/=3
        else if (n = 1)
            return ans
        else {
            sr:=sqrt(n), done:=true, i:=6
            ; try to divide the checked number by all numbers till its square root.
            while (i <= sr+6) {
                if !Mod(n, i-1) { ; is n divisible by i-1?
                    ans.push(i-1), n/=i-1, done:=false
                    break
                }
                if !Mod(n, i+1) { ; is n divisible by i+1?
                    ans.push(i+1), n/=i+1, done:=false
                    break
                }
                i += 6
            }
        }
    }
    ans.push(n)
    return ans
}
