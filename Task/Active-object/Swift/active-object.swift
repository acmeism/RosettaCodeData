// For NSObject, NSTimeInterval and NSThread
import Foundation
// For PI and sin
import Darwin

class ActiveObject:NSObject {

    let sampling = 0.1
    var K: (t: NSTimeInterval) -> Double
    var S: Double
    var t0, t1: NSTimeInterval
    var thread = NSThread()

    func integrateK() {
        t0 = t1
        t1 += sampling
        S += (K(t:t1) + K(t: t0)) * (t1 - t0) / 2
    }

    func updateObject() {
        while true {
            integrateK()
            usleep(100000)
        }
    }

    init(function: (NSTimeInterval) -> Double) {
        S = 0
        t0 = 0
        t1 = 0
        K = function
        super.init()
        thread = NSThread(target: self, selector: "updateObject", object: nil)
        thread.start()
    }

    func Input(function: (NSTimeInterval) -> Double) {
        K = function

    }

    func Output() -> Double {
        return S
    }

}

// main
func sine(t: NSTimeInterval) -> Double {
    let f = 0.5

    return sin(2 * M_PI * f * t)
}

var activeObject = ActiveObject(function: sine)

var date = NSDate()

sleep(2)

activeObject.Input({(t: NSTimeInterval) -> Double in return 0.0})

usleep(500000)

println(activeObject.Output())
