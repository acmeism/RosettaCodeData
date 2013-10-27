func mean_angle(deg []float64) float64 {
    var ss, sc float64
    for _, x := range deg {
        s, c := math.Sincos(x * math.Pi / 180)
        ss += s
        sc += c
    }
    return math.Atan2(ss, sc) * 180 / math.Pi
}
