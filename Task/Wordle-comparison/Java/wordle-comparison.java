import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class WordleComparison {

   public static void main(String[] args) {
      List<TwoWords> pairs = List.of( new TwoWords("ALLOW", "LOLLY"), new TwoWords("ROBIN", "SONIC"),
         new TwoWords("CHANT", "LATTE"), new TwoWords("We're", "She's"), new TwoWords("NOMAD", "MAMMA") );

      for ( TwoWords pair : pairs ) {
         System.out.println(pair.answer + " v " + pair.guess + " -> " + wordle(pair.answer, pair.guess));
      }
   }

   private static List<Colour> wordle(String answer, String guess) {
      final int guessLength = guess.length();
      if ( answer.length() != guessLength ) {
          throw new AssertionError("The two words must be of the same length.");
      }

      String answerCopy = answer;
      List<Colour> result = Stream.generate( () -> Colour.GREY ).limit(guessLength).collect(Collectors.toList());
      for ( int i = 0; i < guessLength; i++ ) {
          if ( answer.charAt(i) == guess.charAt(i) ) {
              answerCopy = answerCopy.substring(0, i) + NULL + answerCopy.substring(i + 1);
              result.set(i, Colour.GREEN);
          }
      }

      for ( int i = 0; i < guessLength; i++ ) {
          int index = answerCopy.indexOf(guess.charAt(i));
          if ( index >= 0 ) {
              answerCopy = answerCopy.substring(0, index) + NULL + answerCopy.substring(index + 1);
              result.set(i, Colour.YELLOW);
          }
      }
      return result;
   }

   private enum Colour { GREEN, GREY, YELLOW }

   private static record TwoWords(String answer, String guess) {}

   private static final char NULL = '\0';

}
