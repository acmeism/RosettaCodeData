import arrays {sum, min}

fn hourglass_flipper(hourglasses []int, target int) (int, []int) {
    mut flippers := hourglasses.clone()

    mut series := []int{}
    for _ in 0..10000 {
        n := min<int>(flippers) or {flippers[0]}
        series << n
        for i in 0..flippers.len {
            flippers[i] -= n
        }
        for i, flipper in flippers {
            if flipper == 0 {
                flippers[i] = hourglasses[i]
            }
        }
        for start := series.len - 1; start >= 0; start-- {
            if sum<int>(series[start..]) or {-1} == target {
                return start, series
            }
        }
    }
    return 0, []int{}
}

fn main() {
    print("Flip an hourglass every time it runs out of grains, ")
    println("and note the interval in time.")
    hgs := [[4, 7], [5, 7, 31]]
    ts := [9, 36]
    for i in 0..hgs.len {
        start, series := hourglass_flipper(hgs[i], ts[i])
        end := series.len - 1
        println("\nSeries: $series")
        print("Use hourglasses from indices $start to $end (inclusive) to sum ")
        println("${ts[i]} using ${hgs[i]}")
    }
}
