import "scheduler" for Scheduler
import "timer" for Timer

var Interval = 0

class Integrator {
    construct new() {
        _sum = 0
    }

    input(k) {
        _k = k
        _v0 = k.call(0)
        _t = 0
        _running = true
        integrate_()
    }

    output { _sum }

    stop() {
        _running = false
    }

    integrate_() {
        while (_running) {
            Timer.sleep(1)
            update_()
        }
    }

    update_() {
        _t = _t + Interval
        var v1 = _k.call(_t)
        var trap = Interval * (_v0 + v1) / 2
        _sum = _sum + trap
        _v0 = v1
    }
}

var integrator = Integrator.new()
Scheduler.add {
    Interval = 2 / 1550  // machine specific value
    integrator.input(Fn.new { |t| (Num.pi * t).sin })
}
Timer.sleep(2000)

Scheduler.add {
    Interval = 0.5 / 775 // machine specific value
    integrator.input(Fn.new { |t| 0 })
}
Timer.sleep(500)

integrator.stop()
System.print(integrator.output)
