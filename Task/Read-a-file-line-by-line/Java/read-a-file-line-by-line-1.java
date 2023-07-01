import java.io.BufferedReader;
import java.io.FileReader;

/**
 * Reads a file line by line, processing each line.
 *
 * @author  $Author$
 * @version $Revision$
 */
public class ReadFileByLines {
    private static void processLine(int lineNo, String line) {
        // ...
    }

    public static void main(String[] args) {
        for (String filename : args) {
            BufferedReader br = null;
            FileReader fr = null;
            try {
                fr = new FileReader(filename);
                br = new BufferedReader(fr);
                String line;
                int lineNo = 0;
                while ((line = br.readLine()) != null) {
                    processLine(++lineNo, line);
                }
            }
            catch (Exception x) {
                x.printStackTrace();
            }
            finally {
                if (fr != null) {
                    try {br.close();} catch (Exception ignoreMe) {}
                    try {fr.close();} catch (Exception ignoreMe) {}
                }
            }
        }
    }
}
