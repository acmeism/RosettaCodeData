import time
import sync

fn main() {
	mut wg := sync.new_waitgroup()
	test_arr := [3, 2, 1, 4, 1, 7]
	wg.add(test_arr.len)
	for i, value in test_arr {
		go sort(i, value, mut wg)
	}
	wg.wait()
	println('Printed sorted array')
}

fn sort(id int, value int, mut wg sync.WaitGroup) {
	time.sleep(value * time.millisecond) // can change duration to second or others
	println(value)
	wg.done()
}
