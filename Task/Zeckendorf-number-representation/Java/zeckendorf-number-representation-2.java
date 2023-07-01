import java.util.ArrayList;
import java.util.List;

public class Zeckendorf {

    private List<Integer> getFibList(final int maxNum, final int n1, final int n2, final List<Integer> fibs){
        if(n2 > maxNum) return fibs;

        fibs.add(n2);

        return getFibList(maxNum, n2, n1 + n2, fibs);
    }

    public String getZeckendorf(final int num) {
        if (num <= 0) return "0";

        final List<Integer> fibs = getFibList(num, 1, 2, new ArrayList<Integer>(){{ add(1); }});

        return getZeckString("", num, fibs.size() - 1, fibs);
    }

    private String getZeckString(final String zeck, final int num, final int index, final List<Integer> fibs){
        final int curFib = fibs.get(index);
        final boolean placeZeck = num >= curFib;

        final String outString = placeZeck ? zeck + "1" : zeck + "0";
        final int outNum = placeZeck ? num - curFib : num;

        if(index == 0) return outString;

        return  getZeckString(outString, outNum, index - 1, fibs);
    }

    public static void main(final String[] args) {
        final Zeckendorf zeckendorf = new Zeckendorf();

        for(int i =0; i <= 20; i++){
            System.out.println("Z("+ i +"):\t" + zeckendorf.getZeckendorf(i));
        }
    }
}
