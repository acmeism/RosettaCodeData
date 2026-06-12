class ChebyshevCoefficients {
    static double map(double x, double min_x, double max_x, double min_to, double max_to) {
        return (x - min_x) / (max_x - min_x) * (max_to - min_to) + min_to
    }

    static void chebyshevCoef(Closure<Double> func, double min, double max, double[] coef) {
        final int N = coef.length
        for (int i = 0; i < N; i++) {
            double m = map(Math.cos(Math.PI * (i + 0.5f) / N), -1, 1, min, max)
            double f = func(m) * 2 / N

            for (int j = 0; j < N; j++) {
                coef[j] += f * Math.cos(Math.PI * j * (i + 0.5f) / N)
            }
        }
    }

    static void main(String[] args) {
        final int N = 10
        double[] c = new double[N]
        double min = 0, max = 1
        chebyshevCoef(Math.&cos, min, max, c)

        println("Coefficients:")
        for (double d : c) {
            println(d)
        }
    }
}
