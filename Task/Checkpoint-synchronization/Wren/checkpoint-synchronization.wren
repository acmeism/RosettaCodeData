import "random" for Random
import "scheduler" for Scheduler
import "timer" for Timer
import "./ioutil" for Input

var rgen = Random.new()
var nWorkers = 0
var nTasks = 0
var nFinished = 0

var worker = Fn.new { |id|
    var workTime = rgen.int(100, 1000) // 100..999 msec.
    System.print("Worker %(id) will work for %(workTime) msec.")
    Timer.sleep(workTime)
    nFinished = nFinished + 1
    System.print("Worker %(id) is ready.")
}

var checkPoint = Fn.new {
    while (nFinished != nWorkers) {
        Timer.sleep(10)
    }
    nFinished = 0 // reset
}

var runTasks = Fn.new {
    for (i in 1..nTasks) {
        System.print("\nStarting task number %(i).")
        var first = rgen.int(1, nWorkers + 1) // randomize first worker to start
        // schedule other workers to start while another fiber is sleeping
        for (j in 1..nWorkers) {
            if (j != first) Scheduler.add { worker.call(j) }
        }
        worker.call(first) // start first worker
        checkPoint.call()  // start checkPoint
    }
}

nWorkers = Input.integer("Enter number of workers to use: ", 1)
nTasks   = Input.integer("Enter number of tasks to complete: ", 1)
runTasks.call()
