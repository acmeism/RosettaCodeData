fn gcd(xx int, yy int) int {
    mut x := xx
    mut y := yy
    for y != 0 {
        x, y = y, x%y
    }
    return x
}

fn yellowstone(n int) []int {
    mut m := map[int]bool{}
    mut a := []int{len: n+1}
    for i in 1..4 {
        a[i] = i
        m[i] = true
    }
    mut min := 4
    for c := 4; c <= n; c++ {
        for i := min; ; i++ {
            if !m[i] && gcd(a[c-1], i) == 1 && gcd(a[c-2], i) > 1 {
                a[c] = i
                m[i] = true
                if i == min {
                    min++
                }
                break
            }
        }
    }
    return a[1..]
}

fn main() {
    mut x := []int{len: 100}
    for i in 0..100 {
        x[i] = i + 1
    }
    y := yellowstone(100)
    println("The first 30 Yellowstone numbers are:")
    println(y[..30])
}
