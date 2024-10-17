mutable struct Integrator
    func::Function
    runningsum::Float64
    dt::Float64
    running::Bool
    function Integrator(f::Function, dt::Float64)
        this = new()
        this.func = f
        this.runningsum = 0.0
        this.dt = dt
        this.running = false
        return this
    end
end

function run(integ::Integrator, lastval::Float64 = 0.0)
    lasttime = time()
    while integ.running
        sleep(integ.dt)
        newtime = time()
        measuredinterval = newtime - lasttime
        newval = integ.func(measuredinterval)
        integ.runningsum += (lastval + newval) * measuredinterval / 2.0
        lasttime = newtime
        lastval = newval
    end
end

start!(integ::Integrator) = (integ.running = true; @async run(integ))
stop!(integ) = (integ.running = false)
f1(t) = sin(2π * t)
f2(t) = 0.0

it = Integrator(f1, 0.00001)
start!(it)
sleep(2.0)
it.func = f2
sleep(0.5)
v2 = it.runningsum
println("After 2.5 seconds, integrator value was $v2")
