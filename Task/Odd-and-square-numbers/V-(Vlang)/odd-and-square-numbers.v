import math

fn main() {
    mut pow := 1
    for _ in 0..5 {
        mut low := int(math.ceil(math.sqrt(f64(pow))))
        if low%2 == 0 {
            low++
        }
        pow *= 10
        high := int(math.sqrt(f64(pow)))
        mut odd_sq := []int{}
        for i := low; i <= high; i += 2 {
            odd_sq << i*i
        }
        println("$odd_sq.len odd squares from ${pow/10} to $pow, \b:")
        for i in 0..odd_sq.len {
            print("${odd_sq[i]} ")
            if (i+1)%10 == 0 {
                println('')
            }
        }
        println("\n")
    }
}
