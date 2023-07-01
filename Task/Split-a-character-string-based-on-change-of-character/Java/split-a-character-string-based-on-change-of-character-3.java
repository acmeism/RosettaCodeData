package org.rosettacode;

import java.util.ArrayList;
import java.util.List;


/**
 * This class provides a main method that will, for each arg provided,
 * transform a String into a list of sub-strings, where each contiguous
 * series of characters is made into a String, then the next, and so on,
 * and then it will output them all separated by a comma and a space.
 */
public class SplitStringByCharacterChange {

    public static void main(String... args){
        for (String string : args){

            List<String> resultStrings = splitStringByCharacter(string);
            String output = formatList(resultStrings);
            System.out.println(output);
        }
    }

    /**
     * @param string String - String to split
     * @return List<\String> - substrings of contiguous characters
     */
    public static List<String> splitStringByCharacter(String string){

        List<String> resultStrings = new ArrayList<>();
        StringBuilder currentString = new StringBuilder();

        for (int pointer = 0; pointer < string.length(); pointer++){

            currentString.append(string.charAt(pointer));

            if (pointer == string.length() - 1
                    || currentString.charAt(0) != string.charAt(pointer + 1)) {
                resultStrings.add(currentString.toString());
                currentString = new StringBuilder();
            }
        }

        return resultStrings;
    }

    /**
     * @param list List<\String> - list of strings to format as a comma+space-delimited string
     * @return String
     */
    public static String formatList(List<String> list){

        StringBuilder output = new StringBuilder();

        for (int pointer = 0; pointer < list.size(); pointer++){
            output.append(list.get(pointer));

            if (pointer != list.size() - 1){
                output.append(", ");
            }
        }

        return output.toString();
    }
}
