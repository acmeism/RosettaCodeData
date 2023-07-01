import rand
import time

// representation of time.Time is nanosecond, actual resolution system specific
struct RateStateS {
mut:
    last_flush time.Time
    period    time.Duration
    tick_count int
}

fn (mut p_rate RateStateS) tic_rate() {
    p_rate.tick_count++
    now := time.now()
    if now-p_rate.last_flush >= p_rate.period {
        // TPS Report
        mut tps := 0.0
        if p_rate.tick_count > 0 {
            tps = f64(p_rate.tick_count) / (now-p_rate.last_flush).seconds()
        }
        println("$tps tics per second.")

        // Reset
        p_rate.tick_count = 0
        p_rate.last_flush = now
    }
}

fn something_we_do() {
    time.sleep(time.Duration(i64(9e7) + rand.i64n(i64(2e7)) or {i64(0)})) // sleep about .1 second.
}

fn main() {
    start := time.now()

    mut rate_watch := RateStateS{
        last_flush: start,
        period:    5 * time.second,
    }

    // Loop for twenty seconds
    mut latest := start
    for latest-start < 20*time.second {
        something_we_do()
        rate_watch.tic_rate()
        latest = time.now()
    }
}
