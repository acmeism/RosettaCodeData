Common_sorted_list(nums){
    elements := [], output := []
    for i, num in nums
        for j, d in num
            elements[d] := true
    for val, bool in elements
        output.push(val)
    return output
}
