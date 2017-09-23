/**
 * Integrates input function K over time
 * S + (t1 - t0) * (K(t1) + K(t0)) / 2
 */
public class Integrator {

    public interface Function {
        double apply(double timeSinceStartInSeconds);
    }

    private final long start;
    private volatile boolean running;

    private Function func;
    private double t0;
    private double v0;
    private double sum;

    public Integrator(Function func) {
        this.start = System.nanoTime();
        setFunc(func);
        new Thread(this::integrate).start();
    }

    public void setFunc(Function func) {
        this.func = func;
        v0 = func.apply(0.0);
        t0 = 0;
    }

    public double getOutput() {
        return sum;
    }

    public void stop() {
        running = false;
    }

    private void integrate() {
        running = true;
        while (running) {
            try {
                Thread.sleep(1);
                update();
            } catch (InterruptedException e) {
                return;
            }
        }
    }

    private void update() {
        double t1 = (System.nanoTime() - start) / 1.0e9;
        double v1 = func.apply(t1);
        double rect = (t1 - t0) * (v0 + v1) / 2;
        this.sum += rect;
        t0 = t1;
        v0 = v1;
    }

    public static void main(String[] args) throws InterruptedException {
        Integrator integrator = new Integrator(t -> Math.sin(Math.PI * t));
        Thread.sleep(2000);

        integrator.setFunc(t -> 0.0);
        Thread.sleep(500);

        integrator.stop();
        System.out.println(integrator.getOutput());
    }
}
