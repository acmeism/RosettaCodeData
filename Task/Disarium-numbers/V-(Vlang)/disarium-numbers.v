import strconv

const dmax = 20  // maximum digits
const limit = 20 // maximum number of disariums to find

fn main() {
    // Pre-calculated exponential and power serials
    mut exp1 := [][]u64{len: 1+dmax, init: []u64{len: 11}}
    mut pow1 := [][]u64{len: 1+dmax, init: []u64{len: 11}}

    for i := u64(1); i <= 10; i++ {
        exp1[1][i] = i
    }
    for i := u64(1); i <= 9; i++ {
        pow1[1][i] = i
    }
    pow1[1][10] = 9

    for i := 1; i < dmax; i++ {
        for j := 0; j <= 9; j++ {
            exp1[i+1][j] = exp1[i][j] * 10
            pow1[i+1][j] = pow1[i][j] * u64(j)
        }
        exp1[i+1][10] = exp1[i][10] * 10
        pow1[i+1][10] = pow1[i][10] + pow1[i+1][9]
    }

    // Digits of candidate and values of known low bits
    mut digits := []int{len: 1+dmax} // Digits form
    mut exp2 := []u64{len: 1+dmax} // Number form
    mut pow2 := []u64{len: 1+dmax} // pow2ers form

    mut exp, mut pow, mut min, mut max := u64(0),u64(0),u64(0),u64(0)
    start := 1
    final := dmax
    mut count := 0
    for digit := start; digit <= final; digit++ {
        println("# of digits: $digit")
        mut level := 1
        digits[0] = 0
        for {
            // Check limits derived from already known low bit values
            // to find the most possible candidates
            for 0 < level && level < digit {
                // Reset path to try next if checking in level is done
                if digits[level] > 9 {
                    digits[level] = 0
                    level--
                    digits[level]++
                    continue
                }

                // Update known low bit values
                exp2[level] = exp2[level-1] + exp1[level][digits[level]]
                pow2[level] = pow2[level-1] + pow1[digit+1-level][digits[level]]

                // Max possible value
                pow = pow2[level] + pow1[digit-level][10]

                if pow < exp1[digit][1] { // Try next since upper limit is invalidly low
                    digits[level]++
                    continue
                }

                max = pow % exp1[level][10]
                pow -= max
                if max < exp2[level] {
                    pow -= exp1[level][10]
                }
                max = pow + exp2[level]

                if max < exp1[digit][1] { // Try next since upper limit is invalidly low
                    digits[level]++
                    continue
                }

                // Min possible value
                exp = exp2[level] + exp1[digit][1]
                pow = pow2[level] + 1

                if exp > max || max < pow { // Try next since upper limit is invalidly low
                    digits[level]++
                    continue
                }

                if pow > exp {
                    min = pow % exp1[level][10]
                    pow -= min
                    if min > exp2[level] {
                        pow += exp1[level][10]
                    }
                    min = pow + exp2[level]
                } else {
                    min = exp
                }

                // Check limits existence
                if max < min {
                    digits[level]++ // Try next number since current limits invalid
                } else {
                    level++ // Go for further level checking since limits available
                }
            }

            // All checking is done, escape from the main check loop
            if level < 1 {
                break
            }

            // Finally check last bit of the most possible candidates
            // Update known low bit values
            exp2[level] = exp2[level-1] + exp1[level][digits[level]]
            pow2[level] = pow2[level-1] + pow1[digit+1-level][digits[level]]

            // Loop to check all last bits of candidates
            for digits[level] < 10 {
                // Print out new Disarium number
                if exp2[level] == pow2[level] {
                    mut s := ""
                    for i := dmax; i > 0; i-- {
                        s += "${digits[i]}"
                    }
                    n, _ := strconv.common_parse_uint2(s, 10, 64)
                    println(n)
                    count++
                    if count == limit {
                        println("\nFound the first $limit Disarium numbers.")
                        return
                    }
                }

                // Go to followed last bit candidate
                digits[level]++
                exp2[level] += exp1[level][1]
                pow2[level]++
            }

            // Reset to try next path
            digits[level] = 0
            level--
            digits[level]++
        }
        println('')
    }
}
