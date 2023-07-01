import math
// Fdy is a type for fntion f used in Euler's method.
type Fdy = fn(f64, f64) f64

// euler_step computes a single new value using Euler's method.
// Note that step size h is a parameter, so a variable step size
// could be used.
fn euler_step(f Fdy, x f64, y f64, h f64) f64 {
    return y + h*f(x, y)
}

// Definition of cooling rate.  Note that this has general utility and
// is not specific to use in Euler's method.

// new_cooling_rate returns a fntion that computes cooling rate
// for a given cooling rate constant k.
fn new_cooling_rate(k f64) fn(f64) f64 {
    return fn[k](delta_temp f64) f64 {
        return -k * delta_temp
    }
}

// new_temp_func returns a fntion that computes the analytical solution
// of cooling rate integrated over time.
fn new_temp_func(k f64, ambient_temp f64, initial_temp f64) fn(f64) f64 {
    return fn[ambient_temp,initial_temp,k](time f64) f64 {
        return ambient_temp + (initial_temp-ambient_temp)*math.exp(-k*time)
    }
}

// new_cooling_rate_dy returns a fntion of the kind needed for Euler's method.
// That is, a fntion representing dy(x, y(x)).
//
// Parameters to new_cooling_rate_dy are cooling constant k and ambient
// temperature.
fn new_cooling_rate_dy(k f64, ambient_temp f64) Fdy {
    // note that result is dependent only on the object temperature.
    // there are no additional dependencies on time, so the x parameter
    // provided by euler_step is unused.
    return fn[k,ambient_temp](_ f64, object_temp f64) f64 {
        return new_cooling_rate(k)(object_temp - ambient_temp)
    }
}

fn main() {
    k := .07
    temp_room := 20.0
    temp_object := 100.0
    fcr := new_cooling_rate_dy(k, temp_room)
    analytic := new_temp_func(k, temp_room, temp_object)
    for delta_time in [2.0, 5, 10] {
        println("Step size = ${delta_time:.1f}")
        println(" Time Euler's Analytic")
        mut temp := temp_object
        for time := 0.0; time <= 100; time += delta_time {
            println("${time:5.1f} ${temp:7.3f} ${analytic(time):7.3f}")
            temp = euler_step(fcr, time, temp, delta_time)
        }
        println('')
    }
}
