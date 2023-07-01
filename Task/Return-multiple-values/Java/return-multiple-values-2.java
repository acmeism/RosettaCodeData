Values<String, OutputStream> getValues() {
    return new Values<>("Rosetta Code", System.out);
}

static class Values<X, Y> {
    X x;
    Y y;

    public Values(X x, Y y) {
        this.x = x;
        this.y = y;
    }
}
