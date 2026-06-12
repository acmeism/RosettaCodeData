import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.ByteBuffer;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

public class TOTP_SHA1 {
    private byte[] K;

    public TOTP_SHA1() {
        generateKey();
    }

    /**
     * Generates a random key.
     */
    public void generateKey() {
        // Keys SHOULD be of the length of the HMAC output to facilitate
        // interoperability.
        SecureRandom random = new SecureRandom();
        this.K = new byte[20]; // SHA-1 digest size is 20 bytes
        random.nextBytes(this.K);
    }

    /**
     * Calculates the HMAC-based One-Time Password (HOTP).
     *
     * @param C The counter value.
     * @param digits The number of digits in the HOTP (default: 6).
     * @return The HOTP as an integer.
     */
    public int hotp(long C, int digits) {
        try {
            Mac mac = Mac.getInstance("HmacSHA1");
            SecretKeySpec secretKeySpec = new SecretKeySpec(this.K, "HmacSHA1");
            mac.init(secretKeySpec);

            // Convert counter to big-endian byte array
            ByteBuffer buffer = ByteBuffer.allocate(8);
            buffer.putLong(C);
            byte[] data = buffer.array();

            byte[] hmacResult = mac.doFinal(data);
            return truncate(hmacResult, digits);
        } catch (NoSuchAlgorithmException | InvalidKeyException e) {
            throw new RuntimeException("Error generating HOTP", e);
        }
    }

    /**
     * Overloaded method with default digits = 6
     */
    public int hotp(long C) {
        return hotp(C, 6);
    }

    /**
     * Calculates the counter value based on the current time.
     *
     * @param T1 The time step in seconds (default: 30).
     * @return The counter value as a long.
     */
    public long counterNow(int T1) {
        long secondsSinceEpoch = System.currentTimeMillis() / 1000;
        return (long) Math.floor((double) secondsSinceEpoch / T1);
    }

    /**
     * Overloaded method with default T1 = 30
     */
    public long counterNow() {
        return counterNow(30);
    }

    /**
     * Performs dynamic truncation on the HMAC result.
     *
     * @param hmacResult The HMAC result as bytes.
     * @return The dynamically truncated value as an integer.
     */
    private int dt(byte[] hmacResult) {
        int offset = hmacResult[19] & 0xf;
        int binCode = ((hmacResult[offset] & 0x7f) << 24) |
                      ((hmacResult[offset + 1] & 0xff) << 16) |
                      ((hmacResult[offset + 2] & 0xff) << 8) |
                      (hmacResult[offset + 3] & 0xff);
        return binCode;
    }

    /**
     * Truncates the dynamically truncated value to the specified number of digits.
     *
     * @param hmacResult The HMAC result as bytes.
     * @param digits The number of digits in the HOTP.
     * @return The truncated value as an integer.
     */
    public int truncate(byte[] hmacResult, int digits) {
        int snum = dt(hmacResult);
        return snum % (int) Math.pow(10, digits);
    }

    /**
     * Gets the current key (for testing purposes)
     */
    public byte[] getKey() {
        return this.K.clone();
    }

    /**
     * Sets the key (for testing purposes)
     */
    public void setKey(byte[] key) {
        this.K = key.clone();
    }

    public static void main(String[] args) {
        TOTP_SHA1 totp = new TOTP_SHA1();
        System.out.println(totp.hotp(totp.counterNow()));
    }
}
