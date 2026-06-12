import java.util.Arrays;

public class SumDataType {

    public static void main(String[] args) {
        for ( ObjectStore<?> e : Arrays.asList(new ObjectStore<String>("String"), new ObjectStore<Integer>(23), new ObjectStore<Float>(new Float(3.14159))) ) {
            System.out.println("Object : " + e);
        }
    }

    public static class ObjectStore<T> {
        private T object;
        public ObjectStore(T object) {
            this.object = object;
        }
        @Override
        public String toString() {
            return "value [" + object.toString() + "], type = " + object.getClass();
        }
    }

}
