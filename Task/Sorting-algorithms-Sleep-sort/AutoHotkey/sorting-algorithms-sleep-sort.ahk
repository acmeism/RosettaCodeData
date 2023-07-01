items := [1,5,4,9,3,4]
for i, v in SleepSort(items)
    result .= v ", "
MsgBox, 262144, , % result := "[" Trim(result, ", ") "]"
return

SleepSort(items){
    global Sorted := []
    slp := 50
    for i, v in items{
        fn := Func("PushFn").Bind(v)
        SetTimer, %fn%, % v * -slp
    }
    Sleep % Max(items*) * slp
    return Sorted
}

PushFn(v){
    global Sorted
    Sorted.Push(v)
}
