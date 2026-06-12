import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Arrays;

public class Base64 {

    private static final char[] alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".toCharArray();

    static String base64(InputStream is) throws IOException {
        StringBuilder sb = new StringBuilder();
        int blocks = 0;

        while (true) {
            int c0 = is.read();
            if (c0 == -1)
                break;
            int c1 = is.read();
            int c2 = is.read();

            int block = ((c0 & 0xFF) << 16) | ((Math.max(c1, 0) & 0xFF) << 8) | (Math.max(c2, 0) & 0xFF);

            sb.append(alpha[block >> 18 & 63]);
            sb.append(alpha[block >> 12 & 63]);
            sb.append(c1 == -1 ? '=' : alpha[block >> 6 & 63]);
            sb.append(c2 == -1 ? '=' : alpha[block & 63]);

            if (++blocks == 19) {
                blocks = 0;
                sb.append('\n');
            }
        }

        if (blocks > 0)
            sb.append('\n');

        return sb.toString();
    }

    private static void assertBase64(String expected, byte[] bytes) throws IOException {
        String actual = base64(new ByteArrayInputStream(bytes));
        if (!actual.equals(expected)) {
            throw new IllegalStateException(String.format("Expected %s for %s, but got %s.",
                    expected, Arrays.toString(bytes), actual));
        }
    }

    private static void testBase64() throws IOException {
        assertBase64("", new byte[]{});
        assertBase64("AA==\n", new byte[]{0});
        assertBase64("AAA=\n", new byte[]{0, 0});
        assertBase64("AAAA\n", new byte[]{0, 0, 0});
        assertBase64("AAAAAA==\n", new byte[]{0, 0, 0, 0});
        assertBase64("/w==\n", new byte[]{-1});
        assertBase64("//8=\n", new byte[]{-1, -1});
        assertBase64("////\n", new byte[]{-1, -1, -1});
        assertBase64("/////w==\n", new byte[]{-1, -1, -1, -1});
    }

    public static void main(String[] args) throws IOException {
        testBase64();

        URLConnection conn = new URL("http://rosettacode.org/favicon.ico").openConnection();
        conn.addRequestProperty("User-Agent", "Mozilla"); // To prevent an HTTP 403 error.
        try (InputStream is = conn.getInputStream()) {
            System.out.println(base64(is));
        }
    }
}
