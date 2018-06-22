import core.thread;
import std.datetime;
import std.math;
import std.stdio;

void main() {
    auto func = (double t) => sin(cast(double) PI * t);
    Integrator integrator = new Integrator(func);
    Thread.sleep(2000.msecs);

    integrator.setFunc(t => 0.0);
    Thread.sleep(500.msecs);

    integrator.stop();
    writeln(integrator.getOutput());
}

/**
 * Integrates input function K over time
 * S + (t1 - t0) * (K(t1) + K(t0)) / 2
 */
public class Integrator {
    public alias Function = double function (double);

    private SysTime start;
    private shared bool running;

    private Function func;
    private shared double t0;
    private shared double v0;
    private shared double sum = 0.0;

    public this(Function func) {
        this.start = Clock.currTime();
        setFunc(func);
        new Thread({
            integrate();
        }).start();
    }

    public void setFunc(Function func) {
        this.func = func;
        v0 = func(0.0);
        t0 = 0.0;
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
            Thread.sleep(1.msecs);
            update();
        }
    }

    private void update() {
        import core.atomic;

        Duration t1 = (Clock.currTime() - start);
        double v1 = func(t1.total!"msecs");
        double rect = (t1.total!"msecs" - t0) * (v0 + v1) / 2;
        atomicOp!"+="(this.sum, rect);
        t0 = t1.total!"msecs";
        v0 = v1;
    }
}
