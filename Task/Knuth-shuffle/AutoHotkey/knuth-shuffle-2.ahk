toShuffle:=[1,2,3,4,5,6]
shuffled:=shuffle(toShuffle)
;p(toShuffle) ;because it modifies the original array
;or
;p(shuffled)
shuffle(a)
{
    i := a.Length()
    loop % i-1 {
        Random, j,1,% i
        x := a[i]
        a[i] := a[j]
        a[j] := x
        i--
    }
    return a
}
