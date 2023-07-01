import com.objectwave.utility.*;

public class MultiCombinationsTester {

    public MultiCombinationsTester() throws CombinatoricException {
        Object[] objects = {"iced", "jam", "plain"};
        //Object[] objects = {"abba", "baba", "ab"};
        //Object[] objects = {"aaa", "aa", "a"};
        //Object[] objects = {(Integer)1, (Integer)2, (Integer)3, (Integer)4};
        MultiCombinations mc = new MultiCombinations(objects, 2);
        while (mc.hasMoreElements()) {
            for (int i = 0; i < mc.nextElement().length; i++) {
                System.out.print(mc.nextElement()[i].toString() + " ");
            }
            System.out.println();
        }

        // Extra credit:
        System.out.println("----------");
        System.out.println("The ways to choose 3 items from 10 with replacement = " + MultiCombinations.c(10, 3));
    } // constructor

    public static void main(String[] args) throws CombinatoricException {
        new MultiCombinationsTester();
    }
} // class
