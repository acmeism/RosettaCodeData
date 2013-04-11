import java.io.*;

public class Rot13 {
    public static void main(String[] args) {
        BufferedReader in;
        if (args.length >= 1) {
            for (String file : args) {
                try {
                    in = new BufferedReader(new FileReader(file));
                    String line;
                    while ((line = in.readLine()) != null) {
                        System.out.println(convert(line));
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        } else {
            try {
                in = new BufferedReader(new InputStreamReader(System.in));
                String line;
                while ((line = in.readLine()) != null) {
                    System.out.println(convert(line));
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static String convert(String msg) {
        StringBuilder retVal = new StringBuilder();
        for (char a : msg.toCharArray()) {
            if (a >= 'A' && a <= 'Z') {
                a += 13;
                if (a > 'Z') {
                    a -= 26;
                }
            } else if (a >= 'a' && a <= 'z') {
                a += 13;
                if (a > 'z') {
                    a -= 26;
                }
            }
            retVal.append(a);
        }
        return retVal.toString();
    }
}
