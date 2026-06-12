import "io" for File
import "timer" for Timer
import "./fmt" for Fmt

var prevIdleTime = 0
var prevTotalTime = 0
System.print("CPU usage \% at 1 second intervals:\n")
for (i in 0..9) {
    var line = File.head("/proc/stat", 1)[0][3..-1].trim()
    var times = line.split(" ")[0..7].map { |t| Num.fromString(t) }.toList
    var totalTime = times.reduce { |acc, t| acc + t }
    var idleTime = times[3]
    var deltaIdleTime = idleTime - prevIdleTime
    var deltaTotalTime = totalTime - prevTotalTime
    var cpuUsage = (1 - deltaIdleTime/deltaTotalTime) * 100
    Fmt.print("$d : $6.3f", i, cpuUsage)
    prevIdleTime = idleTime
    prevTotalTime = totalTime
    Timer.wait(1000)
}
