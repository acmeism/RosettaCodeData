import math

proc fn(t, y: float): float =
    result = t * math.sqrt(y)

proc solution(t: float): float =
    result = (t^2 + 4)^2 / 16

proc rk(start, stop, step: float) =
    let nsteps = int(round((stop - start) / step)) + 1
    let delta = (stop - start) / float(nsteps - 1)
    var cur_y = 1.0
    for i in 0..(nsteps - 1):
        let cur_t = start + delta * float(i)

        if abs(cur_t - math.round(cur_t)) < 1e-5:
            echo "y(", cur_t, ") = ", cur_y, ", error = ", solution(cur_t) - cur_y

        let dy1 = step * fn(cur_t, cur_y)
        let dy2 = step * fn(cur_t + 0.5 * step, cur_y + 0.5 * dy1)
        let dy3 = step * fn(cur_t + 0.5 * step, cur_y + 0.5 * dy2)
        let dy4 = step * fn(cur_t + step, cur_y + dy3)

        cur_y += (dy1 + 2.0 * (dy2 + dy3) + dy4) / 6.0

rk(start=0.0, stop=10.0, step=0.1)
