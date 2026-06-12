import java.util.Objects;

public class PrintDebugStatement {
    /**
     * Takes advantage of the stack trace to determine locality for the calling function
     *
     * @param message the message to print
     */
    private static void printDebug(String message) {
        Objects.requireNonNull(message);

        RuntimeException exception = new RuntimeException();
        StackTraceElement[] stackTrace = exception.getStackTrace();
        // index 0 is this method, where the exception was created
        // index 1 is the calling method, at the spot where this method was invoked
        StackTraceElement stackTraceElement = stackTrace[1];
        String fileName = stackTraceElement.getFileName();
        String className = stackTraceElement.getClassName();
        String methodName = stackTraceElement.getMethodName();
        int lineNumber = stackTraceElement.getLineNumber();

        System.out.printf("[DEBUG][%s %s.%s#%d] %s\n", fileName, className, methodName, lineNumber, message);
    }

    private static void blah() {
        printDebug("Made It!");
    }

    public static void main(String[] args) {
        printDebug("Hello world.");
        blah();

        Runnable oops = () -> printDebug("oops");
        oops.run();
    }
}
