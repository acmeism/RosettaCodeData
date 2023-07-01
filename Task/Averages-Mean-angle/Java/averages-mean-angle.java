import java.util.Arrays;

public class AverageMeanAngle {

    public static void main(String[] args) {
        printAverageAngle(350.0, 10.0);
        printAverageAngle(90.0, 180.0, 270.0, 360.0);
        printAverageAngle(10.0, 20.0, 30.0);
        printAverageAngle(370.0);
        printAverageAngle(180.0);
    }

    private static void printAverageAngle(double... sample) {
        double meanAngle = getMeanAngle(sample);
        System.out.printf("The mean angle of %s is %s%n", Arrays.toString(sample), meanAngle);
    }

    public static double getMeanAngle(double... anglesDeg) {
        double x = 0.0;
        double y = 0.0;

        for (double angleD : anglesDeg) {
            double angleR = Math.toRadians(angleD);
            x += Math.cos(angleR);
            y += Math.sin(angleR);
        }
        double avgR = Math.atan2(y / anglesDeg.length, x / anglesDeg.length);
        return Math.toDegrees(avgR);
    }
}
