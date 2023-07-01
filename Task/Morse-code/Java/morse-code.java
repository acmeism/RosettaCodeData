import java.util.*;

public class MorseCode {

    final static String[][] code = {
        {"A", ".-     "}, {"B", "-...   "}, {"C", "-.-.   "}, {"D", "-..    "},
        {"E", ".      "}, {"F", "..-.   "}, {"G", "--.    "}, {"H", "....   "},
        {"I", "..     "}, {"J", ".---   "}, {"K", "-.-    "}, {"L", ".-..   "},
        {"M", "--     "}, {"N", "-.     "}, {"O", "---    "}, {"P", ".--.   "},
        {"Q", "--.-   "}, {"R", ".-.    "}, {"S", "...    "}, {"T", "-      "},
        {"U", "..-    "}, {"V", "...-   "}, {"W", ".-   - "}, {"X", "-..-   "},
        {"Y", "-.--   "}, {"Z", "--..   "}, {"0", "-----  "}, {"1", ".----  "},
        {"2", "..---  "}, {"3", "...--  "}, {"4", "....-  "}, {"5", ".....  "},
        {"6", "-....  "}, {"7", "--...  "}, {"8", "---..  "}, {"9", "----.  "},
        {"'", ".----. "}, {":", "---... "}, {",", "--..-- "}, {"-", "-....- "},
        {"(", "-.--.- "}, {".", ".-.-.- "}, {"?", "..--.. "}, {";", "-.-.-. "},
        {"/", "-..-.  "}, {"-", "..--.- "}, {")", "---..  "}, {"=", "-...-  "},
        {"@", ".--.-. "}, {"\"", ".-..-."}, {"+", ".-.-.  "}, {" ", "/"}}; // cheat a little

    final static Map<Character, String> map = new HashMap<>();

    static {
        for (String[] pair : code)
            map.put(pair[0].charAt(0), pair[1].trim());
    }

    public static void main(String[] args) {
        printMorse("sos");
        printMorse("   Hello     World!");
        printMorse("Rosetta Code");
    }

    static void printMorse(String input) {
        System.out.printf("%s %n", input);

        input = input.trim().replaceAll("[ ]+", " ").toUpperCase();
        for (char c : input.toCharArray()) {
            String s = map.get(c);
            if (s != null)
                System.out.printf("%s ", s);
        }
        System.out.println("\n");
    }
}
