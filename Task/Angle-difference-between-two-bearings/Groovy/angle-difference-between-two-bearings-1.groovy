def angleDifferenceA(double b1, double b2) {
    r = (b2 - b1) % 360.0
    (r > 180.0    ? r - 360.0
    : r <= -180.0 ? r + 360.0
                  : r)
}
