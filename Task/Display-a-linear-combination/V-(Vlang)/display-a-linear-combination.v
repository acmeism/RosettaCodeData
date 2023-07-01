import strings

fn linear_combo(c []int) string {
    mut sb := strings.new_builder(128)
    for i, n in c {
        if n == 0 {
            continue
        }
        mut op := ''
        match true {
        	n < 0 && sb.len == 0 {
            	op = "-"
			}
        	n < 0{
            	op = " - "
			}
        	n > 0 && sb.len == 0 {
            	op = ""
			}
        	else{
            	op = " + "
			}
        }
        mut av := n
        if av < 0 {
            av = -av
        }
        mut coeff := "$av*"
        if av == 1 {
            coeff = ""
        }
        sb.write_string("$op${coeff}e(${i+1})")
    }
    if sb.len == 0 {
        return "0"
    } else {
        return sb.str()
    }
}

fn main() {
    combos := [
        [1, 2, 3],
        [0, 1, 2, 3],
        [1, 0, 3, 4],
        [1, 2, 0],
        [0, 0, 0],
        [0],
        [1, 1, 1],
        [-1, -1, -1],
        [-1, -2, 0, -3],
        [-1],
	]
    for c in combos {
        println("${c:-15}  ->  ${linear_combo(c)}")
    }
}
