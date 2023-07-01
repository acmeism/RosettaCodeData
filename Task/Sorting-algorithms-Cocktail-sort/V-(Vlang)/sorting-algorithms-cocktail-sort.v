fn cocktail(mut arr []int) {
	input := 'Input'
	output := 'Output'
	println('${input : -7s}: ${arr.str()}')
	for {
		mut swapped := false
		for i := 0; i < arr.len - 1; i++ {
			if arr[i] > arr[i + 1] {
				temp := arr[i]
				arr[i] = arr[i + 1]
				arr[i + 1] = temp
				swapped = true
			}
		}
		if !swapped {
			break
		}
		swapped = false
		for i := arr.len - 2; i >= 0; i-- {
			if arr[i] > arr[i + 1] {
				temp := arr[i]
				arr[i] = arr[i + 1]
				arr[i + 1] = temp
				swapped = true
			}
		}
		if !swapped {
			break
		}
	}
	println('${output : -7s}: ${arr.str()}')
}

fn main() {
	mut arr := [6, 9, 1, 4]
	cocktail(mut arr)
	arr = [-8, 15, 1, 4, -3, 20]
	cocktail(mut arr)
}
