;-------------------------------------------
NonoBlock(cells, blocks){
    result := [], line := ""
    for i, v in blocks
        B .= v ", "
    output := cells " cells and [" Trim(B, ", ") "] blocks`n"

    if ((Arr := NonoBlockCreate(cells, blocks)) = "Error")
        return output "No Solution`n"	
    for i, v in arr
        line.= v ";"
    result[line] := true
    result := NonoBlockRecurse(Arr, result)
    output .= NonoBlockShow(result)
    return output
}
;-------------------------------------------
; create cells+1 size array, stack blocks to left with one gap in between
; gaps are represented by negative number
; stack extra gaps to far left
; for example : 6 cells and [2, 1] blocks
; returns [-2, 2, -1, 1, 0, 0, 0]
NonoBlockCreate(cells, blocks){
    Arr := [], B := blocks.Count()
    if !B									; no blocks
        return [0-cells, 0]
    for i, v in blocks{
        total += v
        Arr.InsertAt(1, blocks[B-A_Index+1])
        Arr.InsertAt(1, -1)
    }
    if (cells < total + B-1)				; not possible
        return "Error"
    Arr[1] := total + B-1 - cells
    loop % cells - Arr.Count() + 1
        Arr.Push(0)
    return Arr
}
;-------------------------------------------
; shift negative numbers from left to right recursively.
; preserve at least one gap between blocks.
; [-2, 2, -1, 1, 0, 0, 0]
; [-1, 2, -2, 1, 0, 0, 0]
NonoBlockRecurse(Arr, result, pos:= 1){
    i := pos-1
    while (i < Arr.count())
    {
        if ((B:=Arr[++i])>=0) || (B=-1 && i>1)
            continue
        if (i=Arr.count()-1)
            return result
        Arr[i] := ++B, Arr[i+2] := Arr[i+2] -1
        result := NonoBlockRecurse(Arr.Clone(), result, i)
        line := []
        for k, v in Arr
            line.=v ";"
        result[line] := true
    }
    return result
}
;-------------------------------------------
; represent positve numbers by a block of "#", negative nubmers by a block of "."
NonoBlockShow(result){
    for line in result{
        i := A_Index
        nLine := ""
        for j, val in StrSplit(line, ";")
            loop % Abs(val)
                nLine .= val > 0 ? "#" : "."
        output .= nLine "`n"
    }
    Sort, output, U
    return output
}
;-------------------------------------------
