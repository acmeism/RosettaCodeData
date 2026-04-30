struct Range {
    start f64
    end   f64
}

fn (r Range) contains(value f64) bool {
    return value >= r.start && value < r.end
}

struct RangeValue {
    range Range
    value f64
}

fn adjust_double(val f64, ranges []RangeValue) f64 {
    for rv in ranges {
        if rv.range.contains(val) { return rv.value }
    }
    return val
}

fn main() {
    ranges := [
        RangeValue{Range{0.00, 0.06}, 0.10},
        RangeValue{Range{0.06, 0.11}, 0.18},
        RangeValue{Range{0.11, 0.16}, 0.26},
        RangeValue{Range{0.16, 0.21}, 0.32},
        RangeValue{Range{0.21, 0.26}, 0.38},
        RangeValue{Range{0.26, 0.31}, 0.44},
        RangeValue{Range{0.31, 0.36}, 0.50},
        RangeValue{Range{0.36, 0.41}, 0.54},
        RangeValue{Range{0.41, 0.46}, 0.58},
        RangeValue{Range{0.46, 0.51}, 0.62},
        RangeValue{Range{0.51, 0.56}, 0.66},
        RangeValue{Range{0.56, 0.61}, 0.70},
        RangeValue{Range{0.61, 0.66}, 0.74},
        RangeValue{Range{0.66, 0.71}, 0.78},
        RangeValue{Range{0.71, 0.76}, 0.82},
        RangeValue{Range{0.76, 0.81}, 0.86},
        RangeValue{Range{0.81, 0.86}, 0.90},
        RangeValue{Range{0.86, 0.91}, 0.94},
        RangeValue{Range{0.91, 0.96}, 0.98},
        RangeValue{Range{0.96, 1.01}, 1.00},
    ]

    for val := 0.0; val <= 1.0; val += 0.01 {
        adjusted := adjust_double(val, ranges)
        println("${val:.2f} -> ${adjusted:.2f}")
    }
}
