import java.lang.reflect.Method;

public class ListMethods {
    public int examplePublicInstanceMethod(char c, double d) {
        return 42;
    }

    private boolean examplePrivateInstanceMethod(String s) {
        return true;
    }

    public static void main(String[] args) {
        Class clazz = ListMethods.class;

        System.out.println("All public methods (including inherited):");
        for (Method m : clazz.getMethods()) {
            System.out.println(m);
        }
        System.out.println();
        System.out.println("All declared methods (excluding inherited):");
        for (Method m : clazz.getDeclaredMethods()) {
            System.out.println(m);
        }
    }
}
