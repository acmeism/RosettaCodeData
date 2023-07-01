// basic task fntion
fn final_survivor(n int, kk int) int {
    // argument validation omitted
    mut circle := []int{len: n, init: it}
    k := kk-1
    mut ex_pos := 0
    for circle.len > 1 {
        ex_pos = (ex_pos + k) % circle.len
		circle.delete(ex_pos)
    }
    return circle[0]
}

// extra
fn position(n int, kk int, p int) int {
    // argument validation omitted
    mut circle := []int{len: n, init: it}
    k := kk-1
	mut pos := p
    mut ex_pos := 0
    for circle.len > 1 {
        ex_pos = (ex_pos + k) % circle.len
        if pos == 0 {
            return circle[ex_pos]
        }
        pos--
		circle.delete(ex_pos)
    }
    return circle[0]
}

fn main() {
    // show basic task fntion on given test case
    println(final_survivor(41, 3))
    // show extra fntion on all positions of given test case
    println("Position  Prisoner")
    for i in 0..41 {
        println("${i:5}${position(41, 3, i):10}")
	}
}
