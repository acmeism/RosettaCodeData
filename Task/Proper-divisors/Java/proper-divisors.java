import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

public class Proper{
    public static List<Integer> properDivs(int n){
        List<Integer> divs = new LinkedList<Integer>();
        if(n == 1) return divs;
        divs.add(1);
        for(int x = 2; x < n; x++){
            if(n % x == 0) divs.add(x);
        }

        Collections.sort(divs);

        return divs;
    }

    public static void main(String[] args){
        for(int x = 1; x <= 10; x++){
            System.out.println(x + ": " + properDivs(x));
        }

        int x = 0, count = 0;
        for(int n = 1; n <= 20000; n++){
            if(properDivs(n).size() > count){
                x = n;
                count = properDivs(n).size();
            }
        }
        System.out.println(x + ": " + count);
    }
}
