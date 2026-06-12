import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

public final class AnagramGenerator {

   public static void main(String[] args) throws IOException {
      Map<String, List<String>> wordMap = Files.lines(Path.of("unixdict.txt"))
         .collect(Collectors.groupingBy( w -> w.chars().sorted().mapToObj( i -> String.valueOf((char) i) )
         .collect(Collectors.joining())));

      List<String> words = List.of( "Rosetta code", "Joe Biden", "Clint Eastwood" );
      for ( String word : words ) {
         System.out.println("Two word anagrams of " + word + ":");
         anagramGenerator(word, wordMap);
         System.out.println();
      }
   }

   private static void anagramGenerator(String word, Map<String, List<String>> wordMap) {
      String text = word.chars().mapToObj( i -> (char) i ).filter(Character::isLetter)
         .map(String::valueOf).map(String::toLowerCase).collect(Collectors.joining());
      List<String> textList = text.chars().mapToObj( i -> String.valueOf((char) i) ).toList();
      Set<String> previousLetters = new HashSet<String>();

      for ( int n = text.length() / 2; n >= 1; n-- ) {
         for ( List<String> lettersOneList : createCombinations(textList, n) ) {
               String lettersOne = lettersOneList.stream().sorted().collect(Collectors.joining());
               if ( previousLetters.contains(lettersOne) ) {
                  continue;
               }
               previousLetters.add(lettersOne);

               if ( wordMap.containsKey(lettersOne) ) {
                  List<String> anagramsOne = wordMap.get(lettersOne);
                  List<String> lettersTwoList = listDifference(textList, lettersOneList);
                   String lettersTwo = lettersTwoList.stream().sorted().collect(Collectors.joining());

                   if ( text.length() == 2 * n ) {
                       if ( previousLetters.contains(lettersTwo) ) {
                        continue;
                       }
                       previousLetters.add(lettersTwo);
                   }

                    if ( wordMap.containsKey(lettersTwo) ) {
                     List<String> anagramsTwo = wordMap.get(lettersTwo);
                        for ( String wordOne : anagramsOne ) {
                            for ( String wordTwo : anagramsTwo ) {
                                System.out.println(" " + wordOne + " " + wordTwo);
                            }
                        }
                   }
               }
         }
      }
   }

   private static <T> List<T> listDifference(List<T> removeFrom, List<T> toRemove) {
      List<T> result = new ArrayList<T>(removeFrom);
      toRemove.forEach(result::remove);
      return result;
   }

   private static <T> List<List<T>> createCombinations(List<T> elements, int k) {
      List<List<T>> combinations = new ArrayList<List<T>>();
      createCombinations(elements, k, new ArrayList<T>(), combinations, 0);
      return combinations;
   }

   private static <T> void createCombinations(
         List<T> elements, int k, List<T> accumulator, List<List<T>> combinations, int index) {
      if ( accumulator.size() == k ) {
          combinations.addFirst( new ArrayList<T>(accumulator) );
      } else if ( k - accumulator.size() <= elements.size() - index ) {
          createCombinations(elements, k, accumulator, combinations, index + 1);
          accumulator.add(elements.get(index));
          createCombinations(elements, k, accumulator, combinations, index + 1);
          accumulator.removeLast();
      }
   }

}
