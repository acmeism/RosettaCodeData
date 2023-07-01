fn num_prime_factors(xx int) int {
    mut p := 2
    mut pf := 0
    mut x := xx
    if x == 1 {
        return 1
    }
    for {
        if (x % p) == 0 {
            pf++
            x /= p
            if x == 1 {
                return pf
            }
        } else {
            p++
        }
    }
    return 0
}

fn prime_factors(xx int, mut arr []int) {
    mut p := 2
    mut pf := 0
    mut x := xx
    if x == 1 {
        arr[pf] = 1
        return
    }
    for {
        if (x % p) == 0 {
            arr[pf] = p
            pf++
            x /= p
            if x == 1 {
                return
            }
        } else {
            p++
        }
    }
}

fn sum_digits(xx int) int {
    mut x := xx
    mut sum := 0
    for x != 0 {
        sum += x % 10
        x /= 10
    }
    return sum
}

fn sum_factors(arr []int, size int) int {
    mut sum := 0
    for a := 0; a < size; a++ {
        sum += sum_digits(arr[a])
    }
    return sum
}

fn list_all_smith_numbers(max_smith int) {
    mut arr := []int{}
    mut a := 0
    for a = 4; a < max_smith; a++ {
        numfactors := num_prime_factors(a)
        arr = []int{len: numfactors}
        if numfactors < 2 {
            continue
        }
        prime_factors(a, mut arr)
        if sum_digits(a) == sum_factors(arr, numfactors) {
            print("${a:4} ")
        }
    }
}

fn main() {
    max_smith := 10000
    println("All the Smith Numbers less than $max_smith are:")
    list_all_smith_numbers(max_smith)
    println('')
}
