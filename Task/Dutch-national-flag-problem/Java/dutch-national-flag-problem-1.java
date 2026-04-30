import java.util.Arrays;
import java.util.Random;

public class DutchNationalFlag {
    enum DutchColors {
        RED, WHITE, BLUE
    }

    public static void main(String[] args){
        DutchColors[] balls = new DutchColors[12];
        DutchColors[] values = DutchColors.values();
        Random rand = new Random();

        for (int i = 0; i < balls.length; i++)
            balls[i]=values[rand.nextInt(values.length)];
        System.out.println("Before: " + Arrays.toString(balls));

        Arrays.sort(balls);
        System.out.println("After:  " + Arrays.toString(balls));

        boolean sorted = true;
        for (int i = 1; i < balls.length; i++ ){
            if (balls[i-1].compareTo(balls[i]) > 0){
                sorted=false;
                break;
            }
        }
        System.out.println("Correctly sorted: " + sorted);
    }
}
