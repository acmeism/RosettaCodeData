public class NumericSeparatorSyntax {

    public static void main(String[] args) {
        runTask("Underscore allowed as seperator", 1_000);
        runTask("Multiple consecutive underscores allowed:", 1__0_0_0);
        runTask("Many multiple consecutive underscores allowed:", 1________________________00);
        runTask("Underscores allowed in multiple positions", 1__4__4);
        runTask("Underscores allowed in negative number", -1__4__4);
        runTask("Underscores allowed in floating point number", 1__4__4e-5);
        runTask("Underscores allowed in floating point exponent", 1__4__440000e-1_2);
        //runTask(_100);  does not compile - cannot be before first digit
        //runTask(100_);  does not compile - cannot be after last digit
        //runTask(144_.25);  does not compile - must be within digits
        //runTask(144._25);  does not compile - must be within digits
    }

    private static void runTask(String description, long n) {
        runTask(description, n, "%d");
    }

    private static void runTask(String description, double n) {
        runTask(description, n, "%3.7f");
    }

    private static void runTask(String description, Number n, String format) {
        System.out.printf("%s:  " + format + "%n", description, n);
    }

}
