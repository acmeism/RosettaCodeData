import os

fn main() {
    mut a := 0
    mut b := 0

    text := os.get_raw_line()

    values := text.split(' ')

    a = values[0].int()
    b = values[1].int()

    println('$a + $b = ${a+b}')
}
