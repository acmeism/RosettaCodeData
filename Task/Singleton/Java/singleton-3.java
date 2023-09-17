public enum Singleton {
    INSTANCE;

    // Fields, constructors and methods...
    private int value;
    Singleton() {
        value = 0;
    }
    public int getValue() {
        return value;
    }
    public void setValue(int value) {
        this.value = value;
    }
}
