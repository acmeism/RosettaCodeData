import java.lang.Math;

public class DisariumNumbers {
    public static boolean is_disarium(int num) {
        int n = num;
        int len = Integer.toString(n).length();
        int sum = 0;
        int i = 1;
        while (n > 0) {
            sum += Math.pow(n % 10, len - i + 1);
            n /= 10;
            i ++;
        }
        return sum  == num;
    }

    public static void main(String[] args) {
        int i = 0;
        int count = 0;
        while (count <= 18) {
            if (is_disarium(i)) {
                System.out.printf("%d ", i);
                count++;
            }
            i++;
        }
        System.out.printf("%s", "\n");
    }
}
