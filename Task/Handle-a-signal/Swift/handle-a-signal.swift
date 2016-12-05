import Foundation

let startTime = NSDate()
var signalReceived: sig_atomic_t = 0

signal(SIGINT) { signal in signalReceived = 1 }

for var i = 0;; {
    if signalReceived == 1 { break }
    usleep(500_000)
    if signalReceived == 1 { break }
    print(++i)
}

let endTime = NSDate()
print("Program has run for \(endTime.timeIntervalSinceDate(startTime)) seconds")
