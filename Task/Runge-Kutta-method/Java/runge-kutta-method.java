import static java.lang.Math.*;
import java.util.function.BiFunction;

public class RungeKutta {

    static void runge(BiFunction<Double, Double, Double> yp_func, double[] t,
            double[] y, double dt) {

        for (int n = 0; n < t.length - 1; n++) {
            double dy1 = dt * yp_func.apply(t[n], y[n]);
            double dy2 = dt * yp_func.apply(t[n] + dt / 2.0, y[n] + dy1 / 2.0);
            double dy3 = dt * yp_func.apply(t[n] + dt / 2.0, y[n] + dy2 / 2.0);
            double dy4 = dt * yp_func.apply(t[n] + dt, y[n] + dy3);
            t[n + 1] = t[n] + dt;
            y[n + 1] = y[n] + (dy1 + 2.0 * (dy2 + dy3) + dy4) / 6.0;
        }
    }

    static double calc_err(double t, double calc) {
        double actual = pow(pow(t, 2.0) + 4.0, 2) / 16.0;
        return abs(actual - calc);
    }

    public static void main(String[] args) {
        double dt = 0.10;
        double[] t_arr = new double[101];
        double[] y_arr = new double[101];
        y_arr[0] = 1.0;

        runge((t, y) -> t * sqrt(y), t_arr, y_arr, dt);

        for (int i = 0; i < t_arr.length; i++)
            if (i % 10 == 0)
                System.out.printf("y(%.1f) = %.8f Error: %.6f%n",
                        t_arr[i], y_arr[i],
                        calc_err(t_arr[i], y_arr[i]));
    }
}
