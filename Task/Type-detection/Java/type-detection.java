public class TypeDetection {
    private static void showType(Object a) {
        if (a instanceof Integer) {
            System.out.printf("'%s' is an integer\n", a);
        } else if (a instanceof Double) {
            System.out.printf("'%s' is a double\n", a);
        } else if (a instanceof Character) {
            System.out.printf("'%s' is a character\n", a);
        } else {
            System.out.printf("'%s' is some other type\n", a);
        }
    }

    public static void main(String[] args) {
        showType(5);
        showType(7.5);
        showType('d');
        showType(true);
    }
}
