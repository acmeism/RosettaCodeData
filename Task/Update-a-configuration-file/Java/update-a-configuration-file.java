import java.io.*;
import java.util.*;
import java.util.regex.*;

public class UpdateConfig {

    public static void main(String[] args) {
        if (args[0] == null) {
            System.out.println("filename required");

        } else if (readConfig(args[0])) {
            enableOption("seedsremoved");
            disableOption("needspeeling");
            setOption("numberofbananas", "1024");
            addOption("numberofstrawberries", "62000");
            store();
        }
    }

    private enum EntryType {
        EMPTY, ENABLED, DISABLED, COMMENT
    }

    private static class Entry {
        EntryType type;
        String name, value;

        Entry(EntryType t, String n, String v) {
            type = t;
            name = n;
            value = v;
        }
    }

    private static Map<String, Entry> entries = new LinkedHashMap<>();
    private static String path;

    private static boolean readConfig(String p) {
        path = p;

        File f = new File(path);
        if (!f.exists() || f.isDirectory())
            return false;

        String regexString = "^(;*)\\s*([A-Za-z0-9]+)\\s*([A-Za-z0-9]*)";
        Pattern regex = Pattern.compile(regexString);

        try (Scanner sc = new Scanner(new FileReader(f))){
            int emptyLines = 0;
            String line;
            while (sc.hasNext()) {
                line = sc.nextLine().trim();

                if (line.isEmpty()) {
                    addOption("" + emptyLines++, null, EntryType.EMPTY);

                } else if (line.charAt(0) == '#') {
                    entries.put(line, new Entry(EntryType.COMMENT, line, null));

                } else {
                    line = line.replaceAll("[^a-zA-Z0-9\\x20;]", "");
                    Matcher m = regex.matcher(line);

                    if (m.find() && !m.group(2).isEmpty()) {

                        EntryType t = EntryType.ENABLED;
                        if (!m.group(1).isEmpty())
                            t = EntryType.DISABLED;

                        addOption(m.group(2), m.group(3), t);
                    }
                }
            }
        } catch (IOException e) {
            System.out.println(e);
        }
        return true;
    }

    private static void addOption(String name, String value) {
        addOption(name, value, EntryType.ENABLED);
    }

    private static void addOption(String name, String value, EntryType t) {
        name = name.toUpperCase();
        entries.put(name, new Entry(t, name, value));
    }

    private static void enableOption(String name) {
        Entry e = entries.get(name.toUpperCase());
        if (e != null)
            e.type = EntryType.ENABLED;
    }

    private static void disableOption(String name) {
        Entry e = entries.get(name.toUpperCase());
        if (e != null)
            e.type = EntryType.DISABLED;
    }

    private static void setOption(String name, String value) {
        Entry e = entries.get(name.toUpperCase());
        if (e != null)
            e.value = value;
    }

    private static void store() {
        try (PrintWriter pw = new PrintWriter(path)) {
            for (Entry e : entries.values()) {
                switch (e.type) {
                    case EMPTY:
                        pw.println();
                        break;
                    case ENABLED:
                        pw.format("%s %s%n", e.name, e.value);
                        break;
                    case DISABLED:
                        pw.format("; %s %s%n", e.name, e.value);
                        break;
                    case COMMENT:
                        pw.println(e.name);
                        break;
                    default:
                        break;
                }
            }
            if (pw.checkError()) {
                throw new IOException("writing to file failed");
            }
        } catch (IOException e) {
            System.out.println(e);
        }
    }
}
