import Foundation

for i in [5, 2, 4, 6, 1, 7, 20, 14] {
    let time = dispatch_time(DISPATCH_TIME_NOW,
        Int64(i * Int(NSEC_PER_SEC)))

    dispatch_after(time, dispatch_get_main_queue()) {
        print(i)
    }
}

CFRunLoopRun()
