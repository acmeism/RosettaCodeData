import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

public class DataEncryptionStandard {
    private static byte[] toHexByteArray(String self) {
        byte[] bytes = new byte[self.length() / 2];
        for (int i = 0; i < bytes.length; ++i) {
            bytes[i] = ((byte) Integer.parseInt(self.substring(i * 2, i * 2 + 2), 16));
        }
        return bytes;
    }

    private static void printHexBytes(byte[] self, String label) {
        System.out.printf("%s: ", label);
        for (byte b : self) {
            int bb = (b >= 0) ? ((int) b) : b + 256;
            String ts = Integer.toString(bb, 16);
            if (ts.length() < 2) {
                ts = "0" + ts;
            }
            System.out.print(ts);
        }
        System.out.println();
    }

    public static void main(String[] args) throws Exception {
        String strKey = "0e329232ea6d0d73";
        byte[] keyBytes = toHexByteArray(strKey);
        SecretKeySpec key = new SecretKeySpec(keyBytes, "DES");
        Cipher encCipher = Cipher.getInstance("DES");
        encCipher.init(Cipher.ENCRYPT_MODE, key);
        String strPlain = "8787878787878787";
        byte[] plainBytes = toHexByteArray(strPlain);
        byte[] encBytes = encCipher.doFinal(plainBytes);
        printHexBytes(encBytes, "Encoded");

        Cipher decCipher = Cipher.getInstance("DES");
        decCipher.init(Cipher.DECRYPT_MODE, key);
        byte[] decBytes = decCipher.doFinal(encBytes);
        printHexBytes(decBytes, "Decoded");
    }
}
