import java.util.HashMap;
import java.util.Map;

//  Title:  Determine if a string has all unique characters

public class StringUniqueCharacters {

    public static void main(String[] args) {
        System.out.printf("%-40s  %2s  %10s  %8s  %s  %s%n", "String", "Length", "All Unique", "1st Diff", "Hex", "Positions");
        System.out.printf("%-40s  %2s  %10s  %8s  %s  %s%n", "------------------------", "------", "----------", "--------", "---", "---------");
        for ( String s : new String[] {"", ".", "abcABC", "XYZ ZYX", "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ"} ) {
            processString(s);
        }
    }



    private static void processString(String input) {
        Map<Character,Integer> charMap = new HashMap<>();
        char dup = 0;
        int index = 0;
        int pos1 = -1;
        int pos2 = -1;
        for ( char key : input.toCharArray() ) {
            index++;
            if ( charMap.containsKey(key) ) {
                dup = key;
                pos1 = charMap.get(key);
                pos2 = index;
                break;
            }
            charMap.put(key, index);
        }
        String unique = dup == 0 ? "yes" : "no";
        String diff = dup == 0 ? "" : "'" + dup + "'";
        String hex = dup == 0 ? "" : Integer.toHexString(dup).toUpperCase();
        String position = dup == 0 ? "" : pos1 + " " + pos2;
        System.out.printf("%-40s  %-6d  %-10s  %-8s  %-3s  %-5s%n", input, input.length(), unique, diff, hex, position);
    }

}
