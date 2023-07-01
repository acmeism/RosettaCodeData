const romans = ["I", "III", "IV", "VIII", "XLIX", "CCII", "CDXXXIII", "MCMXC", "MMVIII", "MDCLXVI"]

fn main() {
    for roman in romans {println("${roman:-10} = ${roman_decode(roman)}")}
}

fn roman_decode(roman string) int {
    mut n := 0
    mut last := "O"
	if roman =="" {return n}
    for c in roman {
        match c.ascii_str() {
            "I" {n++}
            "V" {if last == "I" {n += 3}  else {n += 5}}
            "X" {if last == "I" {n += 8}   else {n += 10}}
            "L" {if last == "X" {n += 30}  else {n += 50}}
            "C" {if last == "X" {n += 80}  else {n += 100}}
            "D" {if last == "C" {n += 300} else {n += 500}}
            "M" {if last == "C" {n += 800} else {n += 1000}}
			else {last = c.ascii_str()}
        }
    }
    return n
}
