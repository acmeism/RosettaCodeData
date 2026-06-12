fn two_sum(a []int, target_sum int) (int, int, bool) {
    len := a.len
    if len < 2 {return 0, 0, false}
    for i in 0..len - 1 {
        if a[i] <= target_sum {
            for j in i + 1..len {
                sum := a[i] + a[j]
                if sum == target_sum {return i, j, true}
                if sum > target_sum {break}
            }
        }
		else {break}
    }
    return 0, 0, false
}

fn main() {
    a := [0, 2, 11, 19, 90]
    target_sum := 21
    p1, p2, ok := two_sum(a, target_sum)
    if !ok {println("No two numbers were found whose sum is $target_sum")}
	else {println("The numbers with indices $p1 and $p2 sum to $target_sum")}
}
