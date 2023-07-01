public static double avg(double... arr) {
    double sum = 0.0;
    for (double x : arr) {
        sum += x;
    }
    return sum / arr.length;
}
