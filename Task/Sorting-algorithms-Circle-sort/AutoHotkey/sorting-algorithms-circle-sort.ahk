nums := [6, 7, 8, 9, 2, 5, 3, 4, 1]
while circlesort(nums, 1, nums.Count(), 0)		; 1-based
    continue
for i, v in nums
    output .= v ", "
MsgBox % "[" Trim(output, ", ") "]"
return

circlesort(Arr, lo, hi, swaps){
    if (lo = hi)
        return swaps
    high:= hi
    low := lo
    mid := Floor((hi - lo) / 2)
    while (lo < hi) {
        if (Arr[lo] > Arr[hi]){
            tempVal := Arr[lo], Arr[lo] := Arr[hi], Arr[hi] := tempVal
            swaps++
        }
        lo++
        hi--
    }
    if (lo = hi)
        if (Arr[lo] > Arr[hi+1]){
            tempVal := Arr[lo], Arr[lo] := Arr[hi+1], Arr[hi+1] := tempVal
            swaps++
        }
    swaps := circlesort(Arr, low, low+mid, swaps)
    swaps := circlesort(Arr, low+mid+1, high, swaps)
    return swaps
}
