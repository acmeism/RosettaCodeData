import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class CountTheCoins01 {

   public static void main(String[] args) {
      countCoins(List.of( 1, 2, 3, 4, 5 ), 6);
      countCoins(List.of( 1, 1, 2, 3, 3, 4, 5 ), 6);
      countCoins(List.of( 1, 2, 3, 4, 5, 5, 5, 5, 15, 15, 10, 10, 10, 10, 25, 100 ), 40);
   }

   private static void countCoins(List<Integer> coins, int target) {
      System.out.println("Coins are " + coins + ", target sum is " + target);
      int combinationCount = 0;
      int permutationCount = 0;
       for ( List<Integer> combination : allCombinations(coins) ) {
         final int sum = combination.stream().mapToInt(Integer::intValue).sum();
           if ( sum == target ) {
               combinationCount += 1;
               if ( target <= 6 ) {
                  System.out.println(combination + " sums to " + target);
               }
               for ( List<Integer> permutation : permutations(combination) ) {
                  if ( target <= 6 ) {
                     System.out.println("    permutation: " + permutation);
                  }
                   permutationCount += 1;
               }
           }
       }

       System.out.println("Combinations: " + combinationCount + ", Permutations: " + permutationCount);
       System.out.println();
   }

   private static <T> List<List<T>> permutations(List<T> aList) {
      List<T> list = new ArrayList<T>(aList);
      List<Integer> indexes = Stream.generate( () -> 0 ).limit(list.size()).collect(Collectors.toList());
      List<List<T>> result = Stream.of( list ).limit(1).collect(Collectors.toList());
       int i = 0;
      while ( i < list.size() ) {
          if ( indexes.get(i) < i ) {
            final int j = ( i % 2 == 0 ) ? 0 : indexes.get(i);
            T temp = list.get(j);
            list.set(j, list.get(i));
            list.set(i, temp);
              result.add(list);
              indexes.set(i, indexes.get(i) + 1);
              i = 0;
          } else {
              indexes.set(i, 0);
              i += 1;
          }
      }
      return result;
   }

   private static <T> List<List<T>> allCombinations(List<T> list) {
      List<List<T>> allCombinations = new ArrayList<List<T>>();
      for ( int i = 1; i <= list.size(); i++ ) {
         allCombinations.addAll(combinations(list, i));
      }
      return allCombinations;
   }

   private static <T> List<List<T>> combinations(List<T> list, int choose) {
      List<List<T>> combinations = new ArrayList<List<T>>();
       List<Integer> combination = IntStream.range(0, choose).boxed().collect(Collectors.toList());
       while ( combination.get(choose - 1) < list.size() ) {
           combinations.add(combination.stream().map( i -> list.get(i) ).toList());
           int temp = choose - 1;
           while ( temp != 0 && combination.get(temp) == list.size() - choose + temp ) {
               temp -= 1;
           }
           combination.set(temp, combination.get(temp) + 1);
           for ( int i = temp + 1; i < choose; i++ ) {
            combination.set(i, combination.get(i - 1) + 1);
           }
       }
       return combinations;
   }

}
