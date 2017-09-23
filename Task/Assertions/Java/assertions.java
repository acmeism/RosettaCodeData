public class Assertions {

    public static void main(String[] args) {
        int a = 13;

        // ... some real code here ...

        assert a == 42;
        // Throws an AssertionError when a is not 42.

        assert a == 42 : "Error message";
        // Throws an AssertionError when a is not 42,
        // with "Error message" for the message.
        // The error message can be any non-void expression.
    }
}
