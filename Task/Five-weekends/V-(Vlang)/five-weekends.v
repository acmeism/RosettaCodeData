import math

fn main() {
	mut sum, mut oldsum, mut leap := 0, 0, 0
	mut m, mut x := f64(0), f64(0)
	mut month := []int{len: 12, init: index}
	mo := [4,0,0,3,5,1,3,6,2,4,0,2]
	mon := [31,28,31,30,31,30,31,31,30,31,30,31]
	mont := ["January","February","March","April","May","June",
	"July","August","September","October","November","December"]
	for year in 1900..2101 {
		if year < 2100 {leap = year - 1900} else {leap = year - 1904}
		m = ((year - 1900) % 7) + math.fmod(leap / 4, 7)
		oldsum = sum
		for n in 0..12 {
			month[n] = int(math.fmod(mo[n] + m, 7))
			x = math.fmod(month[n] + 1, 7)
			if x == 2 && mon[n] == 31 {
				sum += 1
				println("${year} - ${mont[n]}")
 			}
		}
		if sum == oldsum {println("${year} - (none)")}
	}
	println("Total: ${sum}")
}
