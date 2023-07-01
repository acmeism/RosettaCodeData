List1 := ["a", "b", "c"]
List2 := ["A", "B", "C"]
List3 := [ 1 ,  2 ,  3 ]
MsgBox, % LoopMultiArrays()

List1 := ["a", "b", "c", "d", "e"]
List2 := ["A", "B", "C", "D"]
List3 := [1,2,3]
MsgBox, % LoopMultiArrays()


LoopMultiArrays() {
    local Result
    For key, value in List1
        Result .= value . List2[key] . List3[key] "`n"
    Return, Result
}
