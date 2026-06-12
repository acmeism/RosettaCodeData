import java.util.*;
import java.util.stream.*;

public class Main {

    // ---------- input tables (Java 15+ text blocks) ----------
    private static final String TABLE = """
Pi                250  BCE
Magic Squares     2200 BCE
Kwarizmi          830  CE
Dice              3000 BCE
Liber Abaci       1202 CE
Euclid's Elements 300  BCE
Euler's Number    1727 CE
The Abacus        1200 CE

""";

    private static final String TABLE2 = """
Pi             250  BCE
Magic Squares  2200 BCE
Kwarizmi       830  CE
Dice           3000 BCE
Liber Abaci    1202 CE
Euler's Number 1727 CE
The Abacus     1200 CE

""";

    /** Turn a line such as "Pi    250 BCE" into a numeric sort key:
        negative for BCE, positive for CE. */
    private static int sortKey(String line) {
        // split on any whitespace, discard empty parts
        String[] parts = line.trim().split("\\s+");
        // the year is the penultimate token
        int year = Integer.parseInt(parts[parts.length - 2]);
        // the last token is either "BCE"/"BC…" or "CE"
        String era = parts[parts.length - 1];
        return era.startsWith("BC") ? -year : year;   // BCE → negative, CE → positive
    }

    /** Sort a multi‑line table chronologically. */
    private static String sortTable(String table) {
        List<String> lines = Arrays.stream(table.split("\n", -1))
                .map(String::trim)               // remove leading/trailing spaces
                .filter(line -> !line.isEmpty()) // keepempty = false
                .collect(Collectors.toList());

        // sort by the computed key
        lines.sort(Comparator.comparingInt(Main::sortKey));

        return String.join("\n", lines);
    }

    public static void main(String[] args) {
        System.out.println("Sorted Table 1:\n" + sortTable(TABLE));
        System.out.println("\nSorted Table 2:\n" + sortTable(TABLE2));
    }
}

