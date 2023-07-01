import "scheduler" for Scheduler
import "timer" for Timer

var a = 3

// add a task
Scheduler.add {
    a = a * a
}
// add another task
Scheduler.add {
    a = a + 1
}

System.print(a)        // still 3
Timer.sleep(3000)      // wait 3 seconds
System.print(a)        // now 3 * 3 + 1 = 10
