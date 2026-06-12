Common_list_elements(nums){
    counter := [], output := []
    for i, num in nums
        for j, d in num
            if ((counter[d] := counter[d] ? counter[d]+1 : 1) = nums.count())
                output.Push(d)
    return output
}
