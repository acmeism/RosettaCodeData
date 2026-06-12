List := [6, 81, 243, 14, 25, 49, 123, 69, 11]
steps := "Initial List `t`t`t" List2str(List) "`n"
while List.Count() > 1
{
    sum := 0, str := ""
    loop 2
    {
        num := min(List*)
        sum += num
        removeFromList(List, num)
        str .= (!str ? "2 smallest numbers: " : " + ") num
    }
    List.Push(sum)
    steps .= str " = " sum "`t" List2str(List) "`n"
}
MsgBox % result := steps
return

removeFromList(ByRef List, num){
    for i, v in List
        if (v = num)
        {
            List.RemoveAt(i)
            break
        }
}
List2str(List){
    for i, v in List
        unsorted_List .= v ", "
    return "[" Trim(unsorted_List, ", ") "]"
}
