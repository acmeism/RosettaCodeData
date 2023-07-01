public class OldRussianMeasures {

    final static String[] keys = {"tochka", "liniya", "centimeter", "diuym",
        "vershok", "piad", "fut", "arshin", "meter", "sazhen", "kilometer",
        "versta", "milia"};

    final static double[] values = {0.000254, 0.00254, 0.01,0.0254,
        0.04445, 0.1778, 0.3048, 0.7112, 1.0, 2.1336, 1000.0,
        1066.8, 7467.6};

    public static void main(String[] a) {
        if (a.length == 2 && a[0].matches("[+-]?\\d*(\\.\\d+)?")) {
            double inputVal = lookup(a[1]);
            if (!Double.isNaN(inputVal)) {
                double magnitude = Double.parseDouble(a[0]);
                double meters = magnitude * inputVal;
                System.out.printf("%s %s to: %n%n", a[0], a[1]);
                for (String k: keys)
                    System.out.printf("%10s: %g%n", k, meters / lookup(k));
                return;
            }
        }
        System.out.println("Please provide a number and unit");

    }

    public static double lookup(String key) {
        for (int i = 0; i < keys.length; i++)
            if (keys[i].equals(key))
                return values[i];
        return Double.NaN;
    }
}
