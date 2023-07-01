import java.io.*;
import java.nio.charset.Charset;

public class AplusB {
    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new InputStreamReader(System.in, Charset.defaultCharset()));
        in.nextToken();
        int a = (int) in.nval;
        in.nextToken();
        int b = (int) in.nval;

        try (Writer out = new OutputStreamWriter(System.out, Charset.defaultCharset())) {
            out.write(Integer.toString(a + b));
        }
    }
}
