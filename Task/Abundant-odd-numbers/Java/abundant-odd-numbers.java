import java.util.ArrayList;
import java.util.List;

public class AbundantOddNumbers {
    private static List<Integer> list = new ArrayList<>();
    private static List<Integer> result = new ArrayList<>();

    public static void main(String[] args) {
        System.out.println("First 25: ");
        abundantOdd(1,100000, 25, false);

        System.out.println("\n\nThousandth: ");
        abundantOdd(1,2500000, 1000, true);

        System.out.println("\n\nFirst over 1bn:");
        abundantOdd(1000000001, 2147483647, 1, false);
    }
    private static void abundantOdd(int start, int finish, int listSize, boolean printOne) {
        for (int oddNum = start; oddNum < finish; oddNum += 2) {
            list.clear();
            for (int toDivide = 1; toDivide < oddNum; toDivide+=2) {
                if (oddNum % toDivide == 0)
                    list.add(toDivide);
            }
            if (sumList(list) > oddNum) {
                if(!printOne)
                    System.out.printf("%5d <= %5d \n",oddNum, sumList(list) );
                result.add(oddNum);
            }
            if(printOne && result.size() >= listSize)
                System.out.printf("%5d <= %5d \n",oddNum, sumList(list) );

            if(result.size() >= listSize) break;
        }
    }
    private static int sumList(List list) {
        int sum = 0;
        for (int i = 0; i < list.size(); i++) {
            String temp = list.get(i).toString();
            sum += Integer.parseInt(temp);
        }
        return sum;
    }
}
