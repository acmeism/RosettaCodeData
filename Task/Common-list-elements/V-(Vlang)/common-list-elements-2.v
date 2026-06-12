fn main()
{
    lls := [
	[[2, 5, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 9, 8, 4], [1, 3, 7, 6, 9]],
        [[2, 2, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 2, 2, 4], [2, 3, 7, 6, 2]],
    ]
    for ll in lls {
        println("Intersection of $ll is:")
        println(common_list_elements(ll))
        println("")
    }

}

fn common_list_elements(md_arr [][]int) []int {
    mut counter := map[int]int{}
    mut output := []int{}
    for sd_arr in md_arr {
        for value in sd_arr {
	    if counter[value] == counter[value] {counter[value] = counter[value] + 1} else { 1 } {
			if counter[value] >= md_arr.len && output.any(it == value) == false {output << value}
			}	
        }
    }
    return output
}
