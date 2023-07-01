import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class AbbreviationsEasy {
    private static final Scanner input = new Scanner(System.in);
    private static final String  COMMAND_TABLE
            =       "  Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy\n" +
                    " COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find\n" +
                    " NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput\n" +
                    " Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO\n" +
                    " MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT\n" +
                    " READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT\n" +
                    " RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus TOP TRAnsfer Type Up";

    public static void main(String[] args) {
        String[]             cmdTableArr = COMMAND_TABLE.split("\\s+");
        Map<String, Integer> cmd_table   = new HashMap<String, Integer>();

        for (String word : cmdTableArr) {  //Populate words and number of caps
            cmd_table.put(word, countCaps(word));
        }

        System.out.print("Please enter your command to verify: ");
        String   userInput  = input.nextLine();
        String[] user_input = userInput.split("\\s+");

        for (String s : user_input) {
            boolean match = false; //resets each outer loop
            for (String cmd : cmd_table.keySet()) {
                if (s.length() >= cmd_table.get(cmd) && s.length() <= cmd.length()) {
                    String temp = cmd.toUpperCase();
                    if (temp.startsWith(s.toUpperCase())) {
                        System.out.print(temp + " ");
                        match = true;
                    }
                }
            }
            if (!match) { //no match, print error msg
                System.out.print("*error* ");
            }
        }
    }

    private static int countCaps(String word) {
        int numCaps = 0;
        for (int i = 0; i < word.length(); i++) {
            if (Character.isUpperCase(word.charAt(i))) {
                numCaps++;
            }
        }
        return numCaps;
    }
}
