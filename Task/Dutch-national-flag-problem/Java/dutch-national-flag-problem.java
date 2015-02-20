import java.util.Arrays;
import java.util.Random;

public class DutchNationalFlag {
    enum DutchColors {
        RED, WHITE, BLUE
    }

    public static void main(String[] args) {
        DutchColors[] balls = new DutchColors[12];

        DutchColors[] values = DutchColors.values();
        Random rand = new Random();
        for (int i = 0; i < balls.length; i++)
            balls[i] = values[rand.nextInt(values.length)];

        System.out.println("Before: " + Arrays.toString(balls));

        dutchNationalFlagSort(balls);

        System.out.println("After : " + Arrays.toString(balls));
    }

    private static void dutchNationalFlagSort(DutchColors[] items) {
        int lo = 0, mid = 0, hi = items.length - 1;

        while (mid <= hi)
            switch (items[mid]) {
                case RED:
                    swap(items, lo++, mid++);
                    break;
                case WHITE:
                    mid++;
                    break;
                case BLUE:
                    swap(items, mid, hi--);
                    break;
            }
    }

    private static void swap(DutchColors[] arr, int a, int b) {
        DutchColors tmp = arr[a];
        arr[a] = arr[b];
        arr[b] = tmp;
    }
}
