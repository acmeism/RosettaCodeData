import java.math.BigInteger;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AsciiArtDiagramConverter {

    private static final String TEST = "+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\r\n" +
            "|                      ID                       |\r\n" +
            "+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\r\n" +
            "|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |\r\n" +
            "+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\r\n" +
            "|                    QDCOUNT                    |\r\n" +
            "+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\r\n" +
            "|                    ANCOUNT                    |\r\n" +
            "+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\r\n" +
            "|                    NSCOUNT                    |\r\n" +
            "+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+\r\n" +
            "|                    ARCOUNT                    |\r\n" +
            "+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+";

    public static void main(String[] args) {
        validate(TEST);
        display(TEST);
        Map<String,List<Integer>> asciiMap = decode(TEST);
        displayMap(asciiMap);
        displayCode(asciiMap, "78477bbf5496e12e1bf169a4");
    }

    private static void displayCode(Map<String,List<Integer>> asciiMap, String hex) {
        System.out.printf("%nTest string in hex:%n%s%n%n", hex);

        String bin = new BigInteger(hex,16).toString(2);

        //  Zero pad in front as needed
        int length = 0;
        for ( String code : asciiMap.keySet() ) {
            List<Integer> pos = asciiMap.get(code);
            length += pos.get(1) - pos.get(0) + 1;
        }
        while ( length > bin.length() ) {
            bin = "0" + bin;
        }
        System.out.printf("Test string in binary:%n%s%n%n", bin);

        System.out.printf("Name      Size  Bit Pattern%n");
        System.out.printf("-------- -----  -----------%n");
        for ( String code : asciiMap.keySet() ) {
            List<Integer> pos = asciiMap.get(code);
            int start = pos.get(0);
            int end   = pos.get(1);
            System.out.printf("%-8s    %2d  %s%n", code, end-start+1, bin.substring(start, end+1));
        }

    }


    private static void display(String ascii) {
        System.out.printf("%nDiagram:%n%n");
        for ( String s : TEST.split("\\r\\n") ) {
            System.out.println(s);
        }
    }

    private static void displayMap(Map<String,List<Integer>> asciiMap) {
        System.out.printf("%nDecode:%n%n");


        System.out.printf("Name      Size  Start    End%n");
        System.out.printf("-------- -----  -----  -----%n");
        for ( String code : asciiMap.keySet() ) {
            List<Integer> pos = asciiMap.get(code);
            System.out.printf("%-8s    %2d     %2d     %2d%n", code, pos.get(1)-pos.get(0)+1, pos.get(0), pos.get(1));
        }

    }

    private static Map<String,List<Integer>> decode(String ascii) {
        Map<String,List<Integer>> map = new LinkedHashMap<>();
        String[] split = TEST.split("\\r\\n");
        int size = split[0].indexOf("+", 1) - split[0].indexOf("+");
        int length = split[0].length() - 1;
        for ( int i = 1 ; i < split.length ; i += 2 ) {
            int barIndex = 1;
            String test = split[i];
            int next;
            while ( barIndex < length && (next = test.indexOf("|", barIndex)) > 0 ) {
                //  List is start and end of code.
                List<Integer> startEnd = new ArrayList<>();
                startEnd.add((barIndex/size) + (i/2)*(length/size));
                startEnd.add(((next-1)/size) + (i/2)*(length/size));
                String code = test.substring(barIndex, next).replace(" ", "");
                map.put(code, startEnd);
                //  Next bar
                barIndex = next + 1;
            }
        }

        return map;
    }

    private static void validate(String ascii) {
        String[] split = TEST.split("\\r\\n");
        if ( split.length % 2 != 1 ) {
            throw new RuntimeException("ERROR 1:  Invalid number of input lines.  Line count = " + split.length);
        }
        int size = 0;
        for ( int i = 0 ; i < split.length ; i++ ) {
            String test = split[i];
            if ( i % 2 == 0 ) {
                //  Start with +, an equal number of -, end with +
                if ( ! test.matches("^\\+([-]+\\+)+$") ) {
                    throw new RuntimeException("ERROR 2:  Improper line format.  Line = " + test);
                }
                if ( size == 0 ) {
                    int firstPlus = test.indexOf("+");
                    int secondPlus = test.indexOf("+", 1);
                    size = secondPlus - firstPlus;
                }
                if ( ((test.length()-1) % size) != 0 ) {
                    throw new RuntimeException("ERROR 3:  Improper line format.  Line = " + test);
                }
                //  Equally spaced splits of +, -
                for ( int j = 0 ; j < test.length()-1 ; j += size ) {
                    if ( test.charAt(j) != '+' ) {
                        throw new RuntimeException("ERROR 4:  Improper line format.  Line = " + test);
                    }
                    for ( int k = j+1 ; k < j + size ; k++ ) {
                        if ( test.charAt(k) != '-' ) {
                            throw new RuntimeException("ERROR 5:  Improper line format.  Line = " + test);
                        }
                    }
                }
            }
            else {
                //  Vertical bar, followed by optional spaces, followed by name, followed by optional spaces, followed by vdrtical bar
                if ( ! test.matches("^\\|(\\s*[A-Za-z]+\\s*\\|)+$") ) {
                    throw new RuntimeException("ERROR 6:  Improper line format.  Line = " + test);
                }
                for ( int j = 0 ; j < test.length()-1 ; j += size ) {
                    for ( int k = j+1 ; k < j + size ; k++ ) {
                        //  Vertical bar only at boundaries
                        if ( test.charAt(k) == '|' ) {
                            throw new RuntimeException("ERROR 7:  Improper line format.  Line = " + test);
                        }
                    }
                }

            }
        }
    }

}
