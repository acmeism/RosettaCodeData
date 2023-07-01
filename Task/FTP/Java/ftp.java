import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;

public class FTPconn {

    public static void main(String[] args) throws IOException {
        String server = "ftp.hq.nasa.gov";
        int port = 21;
        String user = "anonymous";
        String pass = "ftptest@example.com";

        OutputStream output = null;

        FTPClient ftpClient = new FTPClient();
        try {
            ftpClient.connect(server, port);

            serverReply(ftpClient);

            int replyCode = ftpClient.getReplyCode();
            if (!FTPReply.isPositiveCompletion(replyCode)) {
                System.out.println("Failure. Server reply code: " + replyCode);
                return;
            }

            serverReply(ftpClient);

            if (!ftpClient.login(user, pass)) {
                System.out.println("Could not login to the server.");
                return;
            }

            String dir = "pub/issoutreach/Living in Space Stories (MP3 Files)/";
            if (!ftpClient.changeWorkingDirectory(dir)) {
                System.out.println("Change directory failed.");
                return;
            }

            ftpClient.enterLocalPassiveMode();

            for (FTPFile file : ftpClient.listFiles())
                System.out.println(file);

            String filename = "Can People go to Mars.mp3";
            output = new FileOutputStream(filename);

            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
            if (!ftpClient.retrieveFile(filename, output)) {
                System.out.println("Retrieving file failed");
                return;
            }

            serverReply(ftpClient);

            ftpClient.logout();

        } finally {
            if (output != null)
                output.close();
        }
    }

    private static void serverReply(FTPClient ftpClient) {
        for (String reply : ftpClient.getReplyStrings()) {
            System.out.println(reply);
        }
    }
}
