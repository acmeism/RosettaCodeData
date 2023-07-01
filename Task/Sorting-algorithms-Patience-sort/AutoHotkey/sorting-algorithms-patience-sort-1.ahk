PatienceSort(A){
    P:=0, Pile:=[], Result:=[]
    for k, v in A
    {
        Pushed := 0
        loop % P
        {
            i := A_Index
            if Pile[i].Count() && (Pile[i, 1] >= v)
            {
                Pile[i].InsertAt(1, v)
                pushed := true
                break
            }
        }
        if Pushed
            continue
        P++
        Pile[p] := []
        Pile[p].InsertAt(1, v)
    }

    ; optional to show steps ;;;;;;;;;;;;;;;;;;;;;;;
    loop % P
    {
        i := A_Index, step := ""
        for k, v in Pile[i]
            step .= v ", "
        step := "Pile" i " = "  Trim(step, ", ")
        steps .= step "`n"
    }
    MsgBox % steps
    ; end optional ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    loop % A.Count()
    {
        Collect:=[]
        loop % P
            if Pile[A_index].Count()
                Collect.Push(Pile[A_index, 1])

        for k, v in Collect
            if k=1
                m := v
            else if (v < m)
            {
                m := v
                break
            }

        Result.push(m)
        loop % P
            if (m = Pile[A_index, 1])
            {
                Pile[A_index].RemoveAt(1)
                break
            }
    }
    return Result
}
