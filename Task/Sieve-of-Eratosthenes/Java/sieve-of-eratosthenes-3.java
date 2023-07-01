import java.util.ArrayList;
import java.util.List;
 
public class Eratosthenes {
    public List<Integer> sieve(Integer n) {
        List<Integer> primes = new ArrayList<Integer>(n);
        boolean[] isComposite = new boolean[n + 1];
        for(int i = 2; i <= n; i++) {
            if(!isComposite[i]) {
                primes.add(i);
                for(int j = i * i; j <= n; j += i) {
                    isComposite[j] = true;
                }
            }
        }
        return primes;
    }
}
