import java.io.File;
import java.util.Scanner;

public class LongestStringChallenge {

    public static void main(String[] args) throws Exception {
        String lines = "", longest = "";
        try (Scanner sc = new Scanner(new File("lines.txt"))) {
            while(sc.hasNext()) {
                String line = sc.nextLine();
                if (longer(longest, line))
                    lines = longest = line;
                else if (!longer(line, longest))
                    lines = lines.concat("\n").concat(line);
            }
        }
        System.out.println(lines);
    }

    static boolean longer(String a, String b) {
        try {
            String dummy = a.substring(b.length());
        } catch (StringIndexOutOfBoundsException e) {
            return true;
        }
        return false;
    }
}
