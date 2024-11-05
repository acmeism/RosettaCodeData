import rand

const (
	item_arr = ["aleph","beth","gimel","daleth","he","waw","zayin","heth"]
	prob_arr  = [1/5.0, 1/6.0, 1/7.0, 1/8.0, 1/9.0, 1/10.0, 1/11.0, 1759/27720.0]
)

fn main() {
	mut cnt_arr := [8]f64{}
	mut rnum, mut prob := f64(0), f64(0)
	for _ in 1 .. 1000001 {
		rnum = rand.f64n(10)! / 10
		prob = 0
		for idx in 0 .. prob_arr.len {
			prob += prob_arr[idx]
			if rnum < prob {
				cnt_arr[idx]++
				break
			}
		}
	}
	println("Item	Expected	Actual")
	for idx in 0 .. item_arr.len {
		println("${item_arr[idx]}	${prob_arr[idx]:.6f}	${cnt_arr[idx] / 1000000.0:.6f}")
	}
}
