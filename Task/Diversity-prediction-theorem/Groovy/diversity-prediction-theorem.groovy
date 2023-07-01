class DiversityPredictionTheorem {
    private static double square(double d) {
        return d * d
    }

    private static double averageSquareDiff(double d, double[] predictions) {
        return Arrays.stream(predictions)
                .map({ it -> square(it - d) })
                .average()
                .orElseThrow()
    }

    private static String diversityTheorem(double truth, double[] predictions) {
        double average = Arrays.stream(predictions)
                .average()
                .orElseThrow()
        return String.format("average-error : %6.3f%n", averageSquareDiff(truth, predictions)) + String.format("crowd-error   : %6.3f%n", square(truth - average)) + String.format("diversity     : %6.3f%n", averageSquareDiff(average, predictions))
    }

    static void main(String[] args) {
        println(diversityTheorem(49.0, [48.0, 47.0, 51.0] as double[]))
        println(diversityTheorem(49.0, [48.0, 47.0, 51.0, 42.0] as double[]))
    }
}
