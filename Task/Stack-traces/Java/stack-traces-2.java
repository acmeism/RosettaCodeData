public class StackTraceDemo {
    static void inner() {
	StackTracer.printStackTrace();
    }
    static void middle() {
	inner();
    }
    static void outer() {
	middle();
    }
    public static void main(String[] args) {
	outer();
    }
}
