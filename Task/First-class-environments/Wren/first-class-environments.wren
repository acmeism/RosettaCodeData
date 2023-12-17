import "./fmt" for Fmt

var environment = Fn.new {
    class E {
        construct new(value, count) {
            _value = value
            _count = count
        }

        value { _value }
        count { _count }

        hailstone() {
            Fmt.write("$4d", _value)
            if (_value == 1) return
            _count = _count + 1
            _value = (_value%2 == 0) ? _value/2 : 3*_value + 1
        }
    }
    return E
}

// create and initialize the environments
var jobs = 12
var envs = List.filled(jobs, null)
for (i in 0...jobs) envs[i] = environment.call().new(i+1, 0)
System.print("Sequences:")
var done = false
while (!done) {
    for (env in envs) env.hailstone()
    System.print()
    done = true
    for (env in envs) {
        if (env.value != 1) {
            done = false
            break
        }
    }
}
System.print("Counts:")
for (env in envs) Fmt.write("$4d", env.count)
System.print()
