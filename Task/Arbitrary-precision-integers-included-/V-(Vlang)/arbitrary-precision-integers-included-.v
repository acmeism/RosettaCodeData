import math.big
import math

fn main() {

    mut x := u32(math.pow(3,2))
    x = u32(math.pow(4,x))
	mut y := big.integer_from_int(5)
	y = y.pow(x)
	str := y.str()
	println("5^(4^(3^2)) has $str.len digits: ${str[..20]} ... ${str[str.len-20..]}")
}
