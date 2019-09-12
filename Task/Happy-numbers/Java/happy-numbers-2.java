import java.util.Arrays;
import java.util.HashSet;
import java.util.List;

public class HappyNumbers {


    public static void main(String[] args) {

        for (int current = 1, total = 0; total < 8; current++)
            if (isHappy(current)) {
                System.out.println(current);
                total++;
            }
    }


    public static boolean isHappy(int number) {
        HashSet<Integer> cycle = new HashSet<>();
        while (number != 1 && cycle.add(number)) {
            List<String> numStrList = Arrays.asList(String.valueOf(number).split(""));
            number = numStrList.stream().map(i -> Math.pow(Integer.parseInt(i), 2)).mapToInt(i -> i.intValue()).sum();
        }
        return number == 1;
    }
}
