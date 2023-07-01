import java.util.LinkedList;

public class Sieve{
       public static LinkedList<Integer> sieve(int n){
               if(n < 2) return new LinkedList<Integer>();
               LinkedList<Integer> primes = new LinkedList<Integer>();
               LinkedList<Integer> nums = new LinkedList<Integer>();

               for(int i = 2;i <= n;i++){ //unoptimized
                       nums.add(i);
               }

               while(nums.size() > 0){
                       int nextPrime = nums.remove();
                       for(int i = nextPrime * nextPrime;i <= n;i += nextPrime){
                               nums.removeFirstOccurrence(i);
                       }
                       primes.add(nextPrime);
               }
               return primes;
       }
}
