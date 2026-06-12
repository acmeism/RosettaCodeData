First_Missing_Positive(obj){
    Arr := [], i := 0
    for k, v in obj
        Arr[v] := true
    while (++i<Max(obj*))
        if !Arr[i]{
            m := i
            break
        }
    m := m ? m : Max(obj*) + 1
    return m>0 ? m : 1
}
