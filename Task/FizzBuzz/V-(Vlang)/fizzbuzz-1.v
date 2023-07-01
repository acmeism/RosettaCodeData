const (
    fizz = Tuple{true, false}
    buzz = Tuple{false, true}
    fizzbuzz = Tuple{true, true}
)

struct Tuple{
    val1 bool
    val2 bool
}

fn fizz_or_buzz( val int ) Tuple {
    return Tuple{ val % 3 == 0, val % 5 == 0 }
}

fn fizzbuzz( n int ) {
    for i in 1..(n + 1) {
        match fizz_or_buzz(i) {
            fizz { println('Fizz') }
            buzz { println('Buzz') }
            fizzbuzz { println('FizzBuzz') }
            else { println(i) }
        }
    }
}

fn main(){
    fizzbuzz(15)
}
