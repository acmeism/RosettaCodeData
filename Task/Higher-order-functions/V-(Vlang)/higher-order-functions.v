import math.stats

fn higher_order_function(x int, y int, func fn (int, int) int) int {return func(x,y)}

fn main() {
    list := [f32(1.0), 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
	add := fn (x int, y int) int {return x + y}

    a := stats.mean(list.map(it))
    h := stats.mean(list.map(it * it))
    g := stats.mean(list.map(it * it * it))
    println("A = ${a}  G = ${g}  H = ${h}")

	mut result := higher_order_function(3, 5, add)
    println(result)
}
