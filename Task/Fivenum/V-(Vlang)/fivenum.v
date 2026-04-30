import math

fn median(xay []f64, start int, end_inclusive int) f64 {
    size := end_inclusive - start + 1
    if size <= 0 { panic("Array slice cannot be empty") }
    mir := start + size / 2
    if size % 2 == 1 { return xay[mir] }
	else { return (xay[mir - 1] + xay[mir]) / 2.0 }
}

fn fivenum(xay []f64) []f64 {
    if xay.any(math.is_nan(it)) { panic("Unable to deal with arrays containing NaN") }
	mut result := []f64{len: 5}
	mut mir := 0
    mut ay_sorted := xay.clone()
    ay_sorted.sort()
    result[0] = ay_sorted[0]
    result[4] = ay_sorted[ay_sorted.len - 1]
    result[2] = median(ay_sorted, 0, ay_sorted.len - 1)
    mir = ay_sorted.len / 2
    lower_end := if ay_sorted.len % 2 == 1 { mir } else { mir - 1 }
    result[1] = median(ay_sorted, 0, lower_end)
    result[3] = median(ay_sorted, mir, ay_sorted.len - 1)
    return result
}

fn main() {
    xl := [
        [15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0],
        [36.0, 40.0, 7.0, 39.0, 41.0, 15.0],
        [
             0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,  0.73438555,
            -0.03035726,  1.46675970, -0.74621349, -0.72588772,  0.63905160,  0.61501527,
            -0.98983780, -1.00447874, -0.62759469,  0.66206163,  1.04312009, -0.10305385,
             0.75775634,  0.32566578,
        ],
    ]
    for arr in xl {
        println(fivenum(arr))
        println("")
    }
}
