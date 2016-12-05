import Foundation

let globalCenter = NSDistributedNotificationCenter.defaultCenter()
let time = NSDate().timeIntervalSince1970

globalCenter.addObserverForName("OnlyOne", object: nil, queue: NSOperationQueue.mainQueue()) {not in
    if let senderTime = not.userInfo?["time"] as? NSTimeInterval where senderTime != time {
        println("More than one running")
        exit(0)
    } else {
        println("Only one")
    }
}

func send() {
    globalCenter.postNotificationName("OnlyOne", object: nil, userInfo: ["time": time])

    let waitTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC))

    dispatch_after(waitTime, dispatch_get_main_queue()) {
        send()
    }
}

send()
CFRunLoopRun()
