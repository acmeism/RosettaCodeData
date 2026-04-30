const durations = [0, 7, 84, 7259, 86400, 6_000_000]

struct DurationCalculator {
	mut:
	weeks   int
	days    int
	hours   int
	minutes int
	seconds int
}

fn compound_duration(n int) string {
	if n < 0 { return "" }
	if n == 0 { return "0 sec" }
	mut calculator := DurationCalculator{}
	mut divisor := 7 * 24 * 60 * 60
	mut rem := n
	mut result := ""
	calculator.weeks = n / divisor
	rem = n % divisor
	divisor /= 7
	calculator.days = rem / divisor
	rem %= divisor
	divisor /= 24
	calculator.hours = rem / divisor
	rem %= divisor
	divisor /= 60
	calculator.minutes = rem / divisor
	calculator.seconds = rem % divisor
	if calculator.weeks > 0 { result += "${calculator.weeks} wk, " }
	if calculator.days > 0 { result += "${calculator.days} d, " }
	if calculator.hours > 0 { result += "${calculator.hours} hr, " }
	if calculator.minutes > 0 { result += "${calculator.minutes} min, " }
	if calculator.seconds > 0 {	result += "${calculator.seconds} sec" }
    else { result = result.substr(0, result.len - 2) }
	return result
}

fn main() {
	for duration in durations {
		println("${duration}\t-> ${compound_duration(duration)}")
	}
}
