import java.util.HashMap;
import java.util.Map;

public class FourIsTheNumberOfLetters {

    public static void main(String[] args) {
        String [] words = neverEndingSentence(201);
        System.out.printf("Display the first 201 numbers in the sequence:%n%3d: ", 1);
        for ( int i = 0 ; i < words.length ; i++ ) {
            System.out.printf("%2d ", numberOfLetters(words[i]));
            if ( (i+1) % 25 == 0 ) {
                System.out.printf("%n%3d: ", i+2);
            }
        }
        System.out.printf("%nTotal number of characters in the sentence is %d%n", characterCount(words));
        for ( int i = 3 ; i <= 7 ; i++ ) {
            int index = (int) Math.pow(10, i);
            words = neverEndingSentence(index);
            String last = words[words.length-1].replace(",", "");
            System.out.printf("Number of letters of the %s word is %d. The word is \"%s\".  The sentence length is %,d characters.%n", toOrdinal(index), numberOfLetters(last), last, characterCount(words));
        }
    }

    @SuppressWarnings("unused")
    private static void displaySentence(String[] words, int lineLength) {
        int currentLength = 0;
        for ( String word : words ) {
            if ( word.length() + currentLength > lineLength ) {
                String first = word.substring(0, lineLength-currentLength);
                String second = word.substring(lineLength-currentLength);
                System.out.println(first);
                System.out.print(second);
                currentLength = second.length();
            }
            else {
                System.out.print(word);
                currentLength += word.length();
            }
            if ( currentLength == lineLength ) {
                System.out.println();
                currentLength = 0;
            }
            System.out.print(" ");
            currentLength++;
            if ( currentLength == lineLength ) {
                System.out.println();
                currentLength = 0;
            }
        }
        System.out.println();
    }

    private static int numberOfLetters(String word) {
        return word.replace(",","").replace("-","").length();
    }

    private static long characterCount(String[] words) {
        int characterCount = 0;
        for ( int i = 0 ; i < words.length ; i++ ) {
            characterCount += words[i].length() + 1;
        }
        //  Extra space counted in last loop iteration
        characterCount--;
        return characterCount;
    }

    private static String[] startSentence = new String[] {"Four", "is", "the", "number", "of", "letters", "in", "the", "first", "word", "of", "this", "sentence,"};

    private static String[] neverEndingSentence(int wordCount) {
        String[] words = new String[wordCount];
        int index;
        for ( index = 0 ; index < startSentence.length && index < wordCount ; index++ ) {
            words[index] = startSentence[index];
        }
        int sentencePosition = 1;
        while ( index < wordCount ) {
            //  X in the Y
            //  X
            sentencePosition++;
            String word = words[sentencePosition-1];
            for ( String wordLoop : numToString(numberOfLetters(word)).split(" ") ) {
                words[index] = wordLoop;
                index++;
                if ( index == wordCount ) {
                    break;
                }
            }
            // in
            words[index] = "in";
            index++;
            if ( index == wordCount ) {
                break;
            }
            //  the
            words[index] = "the";
            index++;
            if ( index == wordCount ) {
                break;
            }
            //  Y
            for ( String wordLoop : (toOrdinal(sentencePosition) + ",").split(" ") ) {
                words[index] = wordLoop;
                index++;
                if ( index == wordCount ) {
                    break;
                }
            }
        }
        return words;
    }

    private static final String[] nums = new String[] {
            "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
            "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
    };

    private static final String[] tens = new String[] {"zero", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"};

    private static final String numToString(long n) {
        return numToStringHelper(n);
    }

    private static final String numToStringHelper(long n) {
        if ( n < 0 ) {
            return "negative " + numToStringHelper(-n);
        }
        int index = (int) n;
        if ( n <= 19 ) {
            return nums[index];
        }
        if ( n <= 99 ) {
            return tens[index/10] + (n % 10 > 0 ? "-" + numToStringHelper(n % 10) : "");
        }
        String label = null;
        long factor = 0;
        if ( n <= 999 ) {
            label = "hundred";
            factor = 100;
        }
        else if ( n <= 999999) {
            label = "thousand";
            factor = 1000;
        }
        else if ( n <= 999999999) {
            label = "million";
            factor = 1000000;
        }
        else if ( n <= 999999999999L) {
            label = "billion";
            factor = 1000000000;
        }
        else if ( n <= 999999999999999L) {
            label = "trillion";
            factor = 1000000000000L;
        }
        else if ( n <= 999999999999999999L) {
            label = "quadrillion";
            factor = 1000000000000000L;
        }
        else {
            label = "quintillion";
            factor = 1000000000000000000L;
        }
        return numToStringHelper(n / factor) + " " + label + (n % factor > 0 ? " " + numToStringHelper(n % factor ) : "");
    }

    private static Map<String,String> ordinalMap = new HashMap<>();
    static {
        ordinalMap.put("one", "first");
        ordinalMap.put("two", "second");
        ordinalMap.put("three", "third");
        ordinalMap.put("five", "fifth");
        ordinalMap.put("eight", "eighth");
        ordinalMap.put("nine", "ninth");
        ordinalMap.put("twelve", "twelfth");
    }

    private static String toOrdinal(long n) {
        String spelling = numToString(n);
        String[] split = spelling.split(" ");
        String last = split[split.length - 1];
        String replace = "";
        if ( last.contains("-") ) {
            String[] lastSplit = last.split("-");
            String lastWithDash = lastSplit[1];
            String lastReplace = "";
            if ( ordinalMap.containsKey(lastWithDash) ) {
                lastReplace = ordinalMap.get(lastWithDash);
            }
            else if ( lastWithDash.endsWith("y") ) {
                lastReplace = lastWithDash.substring(0, lastWithDash.length() - 1) + "ieth";
            }
            else {
                lastReplace = lastWithDash + "th";
            }
            replace = lastSplit[0] + "-" + lastReplace;
        }
        else {
            if ( ordinalMap.containsKey(last) ) {
                replace = ordinalMap.get(last);
            }
            else if ( last.endsWith("y") ) {
                replace = last.substring(0, last.length() - 1) + "ieth";
            }
            else {
                replace = last + "th";
            }
        }
        split[split.length - 1] = replace;
        return String.join(" ", split);
    }

}
