MsgBox % quicksort("8,4,9,2,1")

quicksort(list)
{
  StringSplit, list, list, `,
  If (list0 <= 1)
    Return list
  pivot := list1
  Loop, Parse, list, `,
  {
    If (A_LoopField < pivot)
      less = %less%,%A_LoopField%
    Else If (A_LoopField > pivot)
      more = %more%,%A_LoopField%
    Else
      pivotlist = %pivotlist%,%A_LoopField%
  }
  StringTrimLeft, less, less, 1
  StringTrimLeft, more, more, 1
  StringTrimLeft, pivotList, pivotList, 1
  less := quicksort(less)
  more := quicksort(more)
  Return less . pivotList . more
}
