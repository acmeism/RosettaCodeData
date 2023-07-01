import java.lang.reflect.Field

@SuppressWarnings("unused")
class ListProperties {
    public int examplePublicField = 42
    private boolean examplePrivateField = true

    static void main(String[] args) {
        ListProperties obj = new ListProperties()
        Class clazz = obj.class

        println "All public fields (including inherited):"
        (clazz.fields).each { Field f ->
            printf "%s\t%s\n", f, f.get(obj)
        }
        println()

        println "All declared fields (excluding inherited):"
        clazz.getDeclaredFields().each { Field f ->
            f.accessible = true
            printf "%s\t%s\n", f, f.get(obj)
        }
    }
}
