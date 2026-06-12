import rand

fn main() {
    mut total_secs := 0
    mut total_steps := 0
    println("Seconds    steps behind    steps ahead")
    println("-------    ------------    -----------")
    for trial in 1..10000 {
        mut sbeh := 0
        mut slen := 100
        mut secs := 0
        for sbeh < slen {
            sbeh++
            for _ in 1..5 {
                if rand.intn(slen) or {0} < sbeh {
                    sbeh++
                }
                slen++
            }
            secs++
            if trial == 1 && secs > 599 && secs < 610 {
                println("$secs        $sbeh            ${slen-sbeh}")
            }
        }
        total_secs += secs
        total_steps += slen
    }
    println("\nAverage secs taken: ${total_secs/10000}")
    println("Average final length of staircase: ${total_steps/10000}")
}
