class Synced {
    public int func (int input) {
        synchronized(Synced.classinfo) {
            // ...
            foo += input;
            // ...
        }
        return arg;
    }
    private static int foo;
}
