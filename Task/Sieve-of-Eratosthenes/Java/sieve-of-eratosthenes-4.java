import java.util.Set;
import java.util.TreeSet;

public class Sieve{
    public static Set<Integer> findPrimeNumbers(int limit) {
    int last = 2;
    TreeSet<Integer> nums = new TreeSet<>();

    if(limit < last) return nums;

    for(int i = last; i <= limit; i++){
      nums.add(i);
    }

    return filterList(nums, last, limit);
  }

  private static TreeSet<Integer> filterList(TreeSet<Integer> list, int last, int limit) {
    int squared = last*last;
    if(squared < limit) {
      for(int i=squared; i <= limit; i += last) {
        list.remove(i);
      }
      return filterList(list, list.higher(last), limit);
    }
    return list;
  }
}
