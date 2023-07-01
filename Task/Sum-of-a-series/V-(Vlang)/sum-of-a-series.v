import math

fn main(){
    println('known:    ${math.pi*math.pi/6}')
    mut sum := f64(0)
    for i :=1e3; i >0; i-- {
        sum += 1/(i*i)
    }
    println('computed: $sum')
}
