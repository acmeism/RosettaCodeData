data := ["Violet", "Red", "Green", "Indigo", "Blue", "Yellow", "Orange"]
result := [], num := 0, Questions :=""

for i, Color1 in data{
    found :=false
    if !result.count(){
        result.Push(Color1)
        continue
    }

    for j, Color2 in result	{
        if (color1 = color2)
            continue
        MsgBox, 262180,, % (Q := "Q" ++num " is " Color1 " > " Color2 "?")
        ifMsgBox, Yes
            Questions .= Q "`t`tYES`n"
        else {
            Questions .= Q "`t`tNO`n"
            result.InsertAt(j, Color1)
            found := true
            break
        }
    }
    if !found
        result.Push(Color1)
}
for i, color in result
    output .= color ", "
MsgBox % Questions "`nSorted Output :`n" Trim(output, ", ")
return
