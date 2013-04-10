import java.io.IOException;
import java.io.InputStream;

public class MainEntry {
    public static void main(String[] args) {
        // the command to execute
        executeCmd("ls -oa");
    }

    private static void executeCmd(String string) {
        InputStream pipedOut = null;
        try {
            Process aProcess = Runtime.getRuntime().exec(string);

            // These two thread shall stop by themself when the process end
            Thread pipeThread = new Thread(new StreamGobber(aProcess.getInputStream()));
            Thread errorThread = new Thread(new StreamGobber(aProcess.getErrorStream()));

            pipeThread.start();
            errorThread.start();

            aProcess.waitFor();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException ie) {
            ie.printStackTrace();
        }
    }
}

//Replace the following thread with your intends reader
class StreamGobber implements Runnable {

    private InputStream Pipe;

    public StreamGobber(InputStream pipe) {
        if(pipe == null) {
            throw new NullPointerException("bad pipe");
        }
        Pipe = pipe;
    }

    public void run() {
        try {
            byte buffer[] = new byte[2048];

            int read = Pipe.read(buffer);
            while(read >= 0) {
                System.out.write(buffer, 0, read);

                read = Pipe.read(buffer);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if(Pipe != null) {
                try {
                    Pipe.close();
                } catch (IOException e) {
                }
            }
        }
    }
}
