/**
 * Integrates input function K over time
 * S + (t1 - t0) * (K(t1) + K(t0)) / 2
 */
class Integrator {
    interface Function {
        double apply(double timeSinceStartInSeconds)
    }

    private final long start
    private volatile boolean running

    private Function func
    private double t0
    private double v0
    private double sum

    Integrator(Function func) {
        this.start = System.nanoTime()
        setFunc(func)
        new Thread({ this.&integrate() }).start()
    }

    void setFunc(Function func) {
        this.func = func
        def temp = func.apply(0.0.toDouble())
        v0 = temp
        t0 = 0.0.doubleValue()
    }

    double getOutput() {
        return sum
    }

    void stop() {
        running = false
    }

    private void integrate() {
        running = true
        while (running) {
            try {
                Thread.sleep(1)
                update()
            } catch (InterruptedException ignored) {
                return
            }
        }
    }

    private void update() {
        double t1 = (System.nanoTime() - start) / 1.0e9
        double v1 = func.apply(t1)
        double rect = (t1 - t0) * (v0 + v1) / 2.0
        this.sum += rect
        t0 = t1
        v0 = v1
    }

    static void main(String[] args) {
        Integrator integrator = new Integrator({ t -> Math.sin(Math.PI * t) })
        Thread.sleep(2000)

        integrator.setFunc({ t -> 0.0.toDouble() })
        Thread.sleep(500)

        integrator.stop()
        System.out.println(integrator.getOutput())
    }
}
