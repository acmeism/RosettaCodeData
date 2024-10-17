fn main() {
    floyd(5)
    floyd(14)
}

fn floyd(rows int) {
	println('Floyd ${rows}:')
    mut num:=0
    for row in 1..rows+2{
		for _ in 1..row{
			num++
			fnum:='  '+num.str()
			print(fnum[fnum.len-3..]+' ')
		}
		println('')
    }
}
