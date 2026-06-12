Shift_list_elements(Arr, dir, n){
    nums := Arr.Clone()
    loop % n
        if InStr(dir, "l")
            nums.Push(nums.RemoveAt(1))
        else
            nums.InsertAt(1, nums.RemoveAt(nums.count()))
    return nums
}
