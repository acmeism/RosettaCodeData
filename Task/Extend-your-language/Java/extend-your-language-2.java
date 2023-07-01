import static If2.if2;
class Main {
    private static void print(String s) {
        System.out.println(s);
    }

    public static void main(String[] args) {
        // prints "both true"
        if2(true, true,
                () -> print("both true"),
                () -> print("first true"),
                () -> print("second true"),
                () -> print("none true"));
    }
}
