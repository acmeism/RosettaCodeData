const
(
	days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	first_days_common = [3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5]
	first_days_leap = [4, 1, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5]
)

fn main() {
	dates := [
		"1800-01-06",
		"1875-03-29",
		"1915-12-07",
		"1970-12-23",
		"2043-05-14",
		"2077-02-12",
		"2101-04-02"
	]
	mut y, mut m, mut d, mut a, mut f, mut w, mut dow := 0,0,0,0,0,0,0
	println("Days of week given by Doomsday rule:")
	for date in dates {
		y = date[0..4].int()
		m = date[5..7].int()
		m--
		d = date[8..10].int()
		a = anchor_day(y)
		f = first_days_common[m]
		if is_leap_year(y) {
			f = first_days_leap[m]
		}
		w = d - f
		if w < 0 {
			w = 7 + w
		}
		dow = (a + w) % 7
		println('$date -> ${days[dow]}')
	}
}

fn anchor_day(y int) int {
	return (2 + 5 *(y % 4) + 4 * (y % 100) + 6 *(y % 400)) % 7
}

fn is_leap_year(y int) bool {
	return y % 4 == 0 && (y % 100 != 0 || y % 400 == 0)
}
