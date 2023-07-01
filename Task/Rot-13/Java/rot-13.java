import java.io.*;

public class Rot13 {

    public static void main(String[] args) throws IOException {
        if (args.length >= 1) {
            for (String file : args) {
                try (InputStream in = new BufferedInputStream(new FileInputStream(file))) {
                    rot13(in, System.out);
                }
            }
        } else {
            rot13(System.in, System.out);
        }
    }

    private static void rot13(InputStream in, OutputStream out) throws IOException {
        int ch;
        while ((ch = in.read()) != -1) {
            out.write(rot13((char) ch));
        }
    }

    private static char rot13(char ch) {
        if (ch >= 'A' && ch <= 'Z') {
            return (char) (((ch - 'A') + 13) % 26 + 'A');
        }
        if (ch >= 'a' && ch <= 'z') {
            return (char) (((ch - 'a') + 13) % 26 + 'a');
        }
        return ch;
    }
}
