import java.lang.reflect.Field;

public class ListFields {
    public int examplePublicField = 42;
    private boolean examplePrivateField = true;

    public static void main(String[] args) throws IllegalAccessException {
        ListFields obj = new ListFields();
        Class clazz = obj.getClass();

        System.out.println("All public fields (including inherited):");
        for (Field f : clazz.getFields()) {
            System.out.printf("%s\t%s\n", f, f.get(obj));
        }
        System.out.println();
        System.out.println("All declared fields (excluding inherited):");
        for (Field f : clazz.getDeclaredFields()) {
            System.out.printf("%s\t%s\n", f, f.get(obj));
        }
    }
}
