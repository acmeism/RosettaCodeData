public class NKTgVerification {

    public static void main(String[] args) {

        // =============================
        // NKTg Planetary Verification
        // =============================

        String[] planets = {
                "Mercury","Venus","Earth","Mars",
                "Jupiter","Saturn","Uranus","Neptune"
        };

        double[] x_km = {
                6.9817930e7, 1.0893900e8, 1.4710000e8, 2.4923000e8,
                8.1662000e8, 1.5065300e9, 3.0013900e9, 4.5589000e9
        };

        double[] v_km_s = {
                38.86, 35.02, 29.29, 24.07,
                13.06, 9.69, 6.8, 5.43
        };

        double[] m_kg = {
                3.301e23, 4.867e24, 5.972e24, 6.417e23,
                1.898e27, 5.683e26, 8.681e25, 1.024e26
        };

        System.out.println("=== NKTg Planetary Mass Verification ===");

        for (int i = 0; i < planets.length; i++) {

            double x_m = x_km[i] * 1e3;
            double v_m_s = v_km_s[i] * 1e3;

            double p = m_kg[i] * v_m_s;
            double NKTg1 = x_m * p;

            double mInterpolated = NKTg1 / (x_m * v_m_s);
            double deltaM = m_kg[i] - mInterpolated;

            System.out.println(planets[i] + ":");
            System.out.printf("  NASA mass        = %.10e kg%n", m_kg[i]);
            System.out.printf("  Interpolated     = %.10e kg%n", mInterpolated);
            System.out.printf("  Delta m          = %.10e kg%n%n", deltaM);
        }

        // =============================
        // Earth 2024 Interpolation
        // =============================

        double NKTg1Earth = 2.664e33;

        String[] dates = {
                "20240101","20240401","20240701",
                "20241001","20241231"
        };

        double[] earthXkm = {
                149600000,149500000,149400000,
                149500000,149600000
        };

        double[] earthVkmS = {
                29.779,29.289,30.289,
                29.779,29.779
        };

        double nasaFixedMass = 5.9722e24;

        System.out.println("=== Earth 2024 Mass Interpolation (NKTg) ===");

        for (int i = 0; i < dates.length; i++) {

            double x_m = earthXkm[i] * 1e3;
            double v_m_s = earthVkmS[i] * 1e3;

            double mInterpolated = NKTg1Earth / (x_m * v_m_s);
            double deltaM = nasaFixedMass - mInterpolated;

            System.out.println(dates[i] + ":");
            System.out.printf("  Interpolated     = %.10e kg%n", mInterpolated);
            System.out.printf("  NASA fixed mass  = %.10e kg%n", nasaFixedMass);
            System.out.printf("  Delta m          = %.10e kg%n%n", deltaM);
        }
    }
}
