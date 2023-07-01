import "random" for Random
import "scheduler" for Scheduler
import "timer" for Timer

var Rand = Random.new()

var ForkInUse = List.filled(5, false)

class Fork {
    construct new(name, index) {
        _name = name
        _index = index
    }

    index { _index }

    pickUp(philosopher) {
        System.print("  %(philosopher) picked up %(_name)")
        ForkInUse[index] = true
    }

    putDown(philosopher) {
        System.print("  %(philosopher) put down %(_name)")
        ForkInUse[index] = false
    }
}

class Philosopher {
    construct new(pname, f1, f2) {
        _pname = pname
        _f1 = f1
        _f2 = f2
    }

    delay() { Timer.sleep(Rand.int(300) + 100) }

    eat() {
        (1..5).each { |bite|  // limit to 5 bites say
            while (true) {
                System.print("%(_pname) is hungry")
                if (!ForkInUse[_f1.index] && !ForkInUse[_f2.index]) {
                    _f1.pickUp(_pname)
                    _f2.pickUp(_pname)
                    break
                }
                System.print("%(_pname) is unable to pick up both forks")
                // try again later
                delay()
            }
            System.print("%(_pname) is eating bite %(bite)")
            // allow time to eat
            delay()
            _f2.putDown(_pname)
            _f1.putDown(_pname)
            // allow other philospohers time to pick up forks
            delay()
        }
    }
}

var diningPhilosophers = Fn.new { |names|
    var size = names.count
    var forks = List.filled(size, null)
    for (i in 0...size) forks[i] = Fork.new("Fork %(i + 1)", i)
    var philosophers = []
    var i = 0
    for (n in names) {
        var i1 = i
        var i2 = (i + 1) % size
        if (i2 < i1) {
            i1 = i2
            i2 = i
        }
        var p = Philosopher.new(n, forks[i1], forks[i2])
        philosophers.add(p)
        i = i + 1
    }
    // choose a philosopher at random to start eating
    var r = Rand.int(size)
    // schedule the others to eat later
    for (i in 0...size) if (i != r) Scheduler.add { philosophers[i].eat() }
    philosophers[r].eat()
}

var names = ["Aristotle", "Kant", "Spinoza", "Marx", "Russell"]
diningPhilosophers.call(names)
