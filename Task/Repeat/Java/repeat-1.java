import java.lang.reflect.Method;

public class Program {
    public static void main(String[] args) throws ReflectiveOperationException {
        Method method = Program.class.getMethod("printRosettaCode");
        repeat(method, 5);
    }

    public static void printRosettaCode() {
        System.out.println("Rosetta Code");
    }

    public static void repeat(Method method, int count) throws ReflectiveOperationException {
        while (count-- > 0)
            method.invoke(null);
    }
}
