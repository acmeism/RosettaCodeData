import "scheduler" for Scheduler
import "timer" for Timer
import "/queue" for Queue

class CountingSemaphore {
    construct new(numRes) {
        _count = numRes
        _queue = Queue.new()
    }

    count { _count }

    acquire(task) {
        if (_count > 0) {
            _count = _count - 1
            return true
        }
        _queue.push(task)
        return false
    }

    release() {
        if (!_queue.isEmpty) {
            var task = _queue.pop()
            task.transfer()
        } else {
            _count = _count + 1
        }
    }
}

var numRes   = 3
var numTasks = 6
var tasks = List.filled(6, null)
var cs = CountingSemaphore.new(numRes)
var main = Fiber.current

var duty = Fn.new { |n|
    System.print("Task %(n) started when count = %(cs.count).")
    var acquired = cs.acquire(Fiber.current)
    if (!acquired) {
        System.print("Task %(n) waiting for semaphore.")
        Fiber.yield() // return to calling fiber in the meantime
    }
    System.print("Task %(n) has acquired the semaphore.")
    Scheduler.add {
        // whilst this fiber is sleeping, start the next task if there is one
        var next = n + 1
        if (next <= numTasks) {
            tasks[next-1].call(next)
        }
    }
    Timer.sleep(2000)
    System.print("Task %(n) has released the semaphore.")
    cs.release()
    if (n == numTasks) main.transfer() // on completion of last task, return to main fiber
}

// create fibers for tasks
for (i in 0..5) tasks[i] = Fiber.new(duty)

// call the first one
tasks[0].call(1)
System.print("\nAll %(numTasks) tasks completed!")
