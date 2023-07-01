public class ReflectionGetSource {

    public static void main(String[] args) {
        new ReflectionGetSource().method1();

    }

    public ReflectionGetSource() {}

    public void method1() {
        method2();
    }

    public void method2() {
        method3();
    }

    public void method3() {
        Throwable t = new Throwable();
        for ( StackTraceElement ste : t.getStackTrace() ) {
            System.out.printf("File Name   = %s%n", ste.getFileName());
            System.out.printf("Class Name  = %s%n", ste.getClassName());
            System.out.printf("Method Name = %s%n", ste.getMethodName());
            System.out.printf("Line number = %s%n%n", ste.getLineNumber());
        }
    }

}
