fn accumulator n {
	result @ i {
		n = `{echo $n + $i | bc}
		result $n
	}
}

fn-x = <={accumulator 1}
x 5
fn-y = <={accumulator 3}
echo <={x 2.3}
echo <={y -3000}
