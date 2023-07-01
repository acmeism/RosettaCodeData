import log

const limits = [[3, 10], [11, 18], [19, 36], [37, 54], [55, 86], [87, 118]]

fn main() {
    for n in [1, 2, 29, 42, 57, 58, 59, 71, 72, 89, 90, 103, 113] {
        row, col := periodic_table(n)
        println("Atomic number ${n} -> ${row}, ${col}")
    }
}

fn periodic_table(n int) (int, int) {
	mut logged := log.Log{}
	mut limit := []int{}
    mut row, mut start, mut end := 0, 0, 0
    if n < 1 || n > 118 {logged.fatal("Atomic number is out of range.")}
    if n == 1 {return 1, 1}
    if n == 2 {return 1, 18}
    if n >= 57 && n <= 71 {return 8, n - 53}
    if n >= 89 && n <= 103 {return 9, n - 85}
    for i := 0; i < limits.len; i++ {
        limit = limits[i]
        if n >= limit[0] && n <= limit[1] {
            row, start, end = i + 2, limit[0], limit[1]
            break
        }
    }
    if n < start + 2 || row == 4 || row == 5 {return row, n - start + 1}
    return row, n - end + 18
}
