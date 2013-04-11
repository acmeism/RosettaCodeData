public class NoFinalize {
    public static final void main(String[] params) {
        NoFinalize nf = new NoFinalize();
    }
    public NoFinalize() {
        System.out.println("created");
    }
    @Override
    protected void finalize() {
        System.out.println("finalized");
    }
}
