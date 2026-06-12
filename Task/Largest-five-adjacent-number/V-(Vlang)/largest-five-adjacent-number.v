import rand
import rand.seed
import strings

fn main() {
    rand.seed(seed.time_seed_array(2))
    mut sb := strings.new_builder(128)
    for _ in 0..1000 {
        sb.write_byte(u8(rand.intn(10) or {0} + 48))
    }
    number := sb.str()
    println('>> $number')
    for i := 99999; i >= 0; i-- {
        quintet := "${i:05}"
        if number.contains(quintet) {
            println("The largest  number formed from 5 adjacent digits ($quintet) is: ${i:6}")
            break
        }
    }
    for i := 0; i <= 99999; i++ {
        quintet := "${i:05}"
        if number.contains(quintet) {
            println("The smallest number formed from 5 adjacent digits ($quintet) is: ${i:6}")
            return
        }
    }
}
