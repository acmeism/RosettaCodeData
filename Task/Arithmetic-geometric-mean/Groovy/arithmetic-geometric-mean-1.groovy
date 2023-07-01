double agm (double a, double g) {
    double an = a, gn = g
    while ((an-gn).abs() >= 10.0**-14) { (an, gn) = [(an+gn)*0.5, (an*gn)**0.5] }
    an
}
