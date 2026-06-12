import java.io.*;
import java.util.*;

public class CsvToTsv {
    public static void main(String[] args) {
        String testfile = "test.tmp";
        String content =
            "a,\"b\"\n" +
            "\"a\",\"b\"\"c\"\n" +
            ",a\n" +
            "a,\"\n" +
            " a , \"b\"\n" +
            "\"12\",34\n" +
            "a\\tb, TAB\n" +
            "a\\\\tb\n" +
            "a\\n\\rb\n" +
            "a\\0b, NUL\n" +
            "a\\rb, RETURN\n" +
            "a\\\\b";

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(testfile))) {
            writer.write(content);
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(testfile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] result = csvTsv(line);
                System.out.printf("%12s => %s%n", result[0], result[1]);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String[] csvTsv(String str) {
        String[] p = str.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1);

        for (int i = 0; i < p.length; i++) {
            String f = p[i];
            long count = f.chars().filter(ch -> ch == '"').count();
            if (count > 1) {
                p[i] = f.trim().replace("\"\"", "\"").replace(" ", "").replace("\"", "");
            } else if (f.equals("\"")) {
                p[i] = "";
            }
        }

        String t = String.join("<TAB>", p);

        String s = str
            .replace("\\", "\\\\")
            .replace("\t", "\\t")
            .replace("\0", "\\0")
            .replace("\n", "\\n")
            .replace("\r", "\\r");

        t = t
            .replace("\\", "\\\\")
            .replace("\t", "\\t")
            .replace("\0", "\\0")
            .replace("\n", "\\n")
            .replace("\r", "\\r");

        return new String[]{s, t};
    }
}

