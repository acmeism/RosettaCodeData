import java.nio.ByteOrder;

public class ShowByteOrder {
    public static void main(String[] args) {
        // Print "BIG_ENDIAN" or "LITTLE_ENDIAN".
        System.out.println(ByteOrder.nativeOrder());
    }
}
