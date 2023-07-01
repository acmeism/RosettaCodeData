import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.UnknownHostException;

public class SingletonApp
{
    private static final int PORT = 65000;  // random large port number
    private static ServerSocket s;

    // static initializer
    static {
        try {
            s = new ServerSocket(PORT, 10, InetAddress.getLocalHost());
        } catch (UnknownHostException e) {
            // shouldn't happen for localhost
        } catch (IOException e) {
            // port taken, so app is already running
            System.out.print("Application is already running,");
            System.out.println(" so terminating this instance.");
            System.exit(0);
        }
    }

    public static void main(String[] args) {
        System.out.print("OK, only this instance is running");
        System.out.println(" but will terminate in 10 seconds.");
        try {
            Thread.sleep(10000);
            if (s != null && !s.isClosed()) s.close();
        } catch (Exception e) {
            System.err.println(e);
        }
    }
}
