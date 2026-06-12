public class AirMass {
    public static void main(String[] args) {
        System.out.println("Angle     0 m              13700 m");
        System.out.println("------------------------------------");
        for (double z = 0; z <= 90; z+= 5) {
            System.out.printf("%2.0f      %11.8f      %11.8f\n",
                            z, airmass(0.0, z), airmass(13700.0, z));
        }
    }

    private static double rho(double a) {
        // the density of air as a function of height above sea level
        return Math.exp(-a / 8500.0);
    }

    private static double height(double a, double z, double d) {
        // a = altitude of observer
        // z = zenith angle (in degrees)
        // d = distance along line of sight
        double aa = RE + a;
        double hh = Math.sqrt(aa * aa + d * d - 2.0 * d * aa * Math.cos(Math.toRadians(180 - z)));
        return hh - RE;
    }

    private static double columnDensity(double a, double z) {
        // integrates density along the line of sight
        double sum = 0.0, d = 0.0;
        while (d < FIN) {
            // adaptive step size to avoid it taking forever
            double delta = Math.max(DD * d, DD);
            sum += rho(height(a, z, d + 0.5 * delta)) * delta;
            d += delta;
        }
        return sum;
    }

    private static double airmass(double a, double z) {
        return columnDensity(a, z) / columnDensity(a, 0.0);
    }

    private static final double RE = 6371000.0; // Earth radius in meters
    private static final double DD = 0.001; // integrate in this fraction of the distance already covered
    private static final double FIN = 10000000.0; // integrate only to a height of 10000km, effectively infinity
}
