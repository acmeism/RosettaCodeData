public class AngleDifference {

    public static double getDifference(double b1, double b2) {
        double r = (b2 - b1) % 360.0;
        if (r < -180.0)
            r += 360.0;
        if (r >= 180.0)
            r -= 360.0;
        return r;
    }

    public static void main(String[] args) {
        System.out.println("Input in -180 to +180 range");
        System.out.println(getDifference(20.0, 45.0));
        System.out.println(getDifference(-45.0, 45.0));
        System.out.println(getDifference(-85.0, 90.0));
        System.out.println(getDifference(-95.0, 90.0));
        System.out.println(getDifference(-45.0, 125.0));
        System.out.println(getDifference(-45.0, 145.0));
        System.out.println(getDifference(-45.0, 125.0));
        System.out.println(getDifference(-45.0, 145.0));
        System.out.println(getDifference(29.4803, -88.6381));
        System.out.println(getDifference(-78.3251, -159.036));

        System.out.println("Input in wider range");
        System.out.println(getDifference(-70099.74233810938, 29840.67437876723));
        System.out.println(getDifference(-165313.6666297357, 33693.9894517456));
        System.out.println(getDifference(1174.8380510598456, -154146.66490124757));
        System.out.println(getDifference(60175.77306795546, 42213.07192354373));
    }
}
