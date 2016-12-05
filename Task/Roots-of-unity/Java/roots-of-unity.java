import java.util.Locale;

public class Test {

    public static void main(String[] a) {
        for (int n = 2; n < 6; n++)
            unity(n);
    }

    public static void unity(int n) {
        System.out.printf("%n%d: ", n);

        //all the way around the circle at even intervals
        for (double angle = 0; angle < 2 * Math.PI; angle += (2 * Math.PI) / n) {

            double real = Math.cos(angle); //real axis is the x axis

            if (Math.abs(real) < 1.0E-3)
                real = 0.0; //get rid of annoying sci notation

            double imag = Math.sin(angle); //imaginary axis is the y axis

            if (Math.abs(imag) < 1.0E-3)
                imag = 0.0;

            System.out.printf(Locale.US, "(%9f,%9f) ", real, imag);
        }
    }
}
