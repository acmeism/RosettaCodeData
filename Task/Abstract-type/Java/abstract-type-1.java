interface Example {
    String stringA = "rosetta";
    String stringB = "code";

    private String methodA() {
        return stringA + " " + stringB;
    }

    default int methodB(int value) {
        return value + 100;
    }

    int methodC(int valueA, int valueB);
}
