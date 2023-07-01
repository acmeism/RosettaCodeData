import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

public class EchoServer {

    public static void main(String[] args) throws IOException {
        try (ServerSocket listener = new ServerSocket(12321)) {
            while (true) {
                Socket conn = listener.accept();
                Thread clientThread = new Thread(() -> handleClient(conn));
                clientThread.start();
            }
        }
    }

    private static void handleClient(Socket connArg) {
        Charset utf8 = StandardCharsets.UTF_8;

        try (Socket conn = connArg) {
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), utf8));

            PrintWriter out = new PrintWriter(
                    new OutputStreamWriter(conn.getOutputStream(), utf8),
                    true);

            String line;
            while ((line = in.readLine()) != null) {
                out.println(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
