import java.io.IOException;
import java.io.InputStream;

public class MainEntry {
    public static void main(String[] args) {
        executeCmd("ls -oa");
    }

    private static void executeCmd(String string) {
        InputStream pipedOut = null;
        try {
            Process aProcess = Runtime.getRuntime().exec(string);
            aProcess.waitFor();

            pipedOut = aProcess.getInputStream();
            byte buffer[] = new byte[2048];
            int read = pipedOut.read(buffer);
            // Replace following code with your intends processing tools
            while(read >= 0) {
                System.out.write(buffer, 0, read);

                read = pipedOut.read(buffer);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException ie) {
            ie.printStackTrace();
        } finally {
            if(pipedOut != null) {
                try {
                    pipedOut.close();
                } catch (IOException e) {
                }
            }
        }
    }


}
