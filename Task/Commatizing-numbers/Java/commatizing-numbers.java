import java.io.File;
import java.util.*;
import java.util.regex.*;

public class CommatizingNumbers {

    public static void main(String[] args) throws Exception {
        commatize("pi=3.14159265358979323846264338327950288419716939937510582"
                + "097494459231", 6, 5, " ");

        commatize("The author has two Z$100000000000000 Zimbabwe notes (100 "
                + "trillion).", 0, 3, ".");

        try (Scanner sc = new Scanner(new File("input.txt"))) {
            while(sc.hasNext())
                commatize(sc.nextLine());
        }
    }

    static void commatize(String s) {
        commatize(s, 0, 3, ",");
    }

    static void commatize(String s, int start, int step, String ins) {
        if (start < 0 || start > s.length() || step < 1 || step > s.length())
            return;

        Matcher m = Pattern.compile("([1-9][0-9]*)").matcher(s.substring(start));
        StringBuffer result = new StringBuffer(s.substring(0, start));

        if (m.find()) {
            StringBuilder sb = new StringBuilder(m.group(1)).reverse();
            for (int i = step; i < sb.length(); i += step)
                sb.insert(i++, ins);
            m.appendReplacement(result, sb.reverse().toString());
        }

        System.out.println(m.appendTail(result));
    }
}
