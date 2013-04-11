public class StackTracer {
    public static void printStackTrace() {
	StackTraceElement[] elems = Thread.currentThread().getStackTrace();

	System.out.println("Stack trace:");
	for (int i = elems.length-1, j = 2 ; i >= 3 ; i--, j+=2) {
	    System.out.printf("%" + j + "s%s.%s%n", "",
		    elems[i].getClassName(), elems[i].getMethodName());
	}
    }
}
