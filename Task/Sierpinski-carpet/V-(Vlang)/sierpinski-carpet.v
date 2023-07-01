import math

fn main() {
	carpet(3)
}

fn carpet(n int) {
    power := int(math.pow(3.0, n))
    for i in 0..power {
        for j in 0..power {
			if in_carpet(i, j) == true {print("*")} else{print(" ")}
		}
		println('')
    }
}

fn in_carpet(x int, y int) bool {
    mut xx := x
    mut yy := y
    for xx != 0 && yy != 0 {
        if xx % 3 == 1 && yy % 3 == 1 {return false}
        xx /= 3
        yy /= 3
    }
    return true
}
