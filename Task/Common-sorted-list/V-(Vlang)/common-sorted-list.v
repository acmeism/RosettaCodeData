fn main() {
    nums := [[5,1,3,8,9,4,8,7], [3,5,9,8,4], [1,3,7,9]]
    println("Distinct sorted union of $nums is:")
    println(common_sorted_list(nums))
}

fn common_sorted_list(nums [][]int) []int {
    mut elements, mut output := map[int]bool{}, []int{}
	
    for num in nums {
        for value in num {
            elements[value] = true
        }
    }

    for key, _ in elements {
        output << key
    }
    output.sort()
    return output
}
