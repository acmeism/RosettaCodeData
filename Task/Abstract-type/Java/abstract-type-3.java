abstract class Example {
    String stringA = "rosetta";
    String stringB = "code";

    private String methodA() {
        return stringA + " " + stringB;
    }

    protected int methodB(int value) {
        return value + 100;
    }

    public abstract int methodC(int valueA, int valueB);
}
