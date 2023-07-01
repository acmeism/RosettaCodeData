import Foundation

let request = NSURLRequest(URL: NSURL(string: "http://rosettacode.org/")!)

// Using trailing closure
NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {res, data, err in

    // data is binary
    if (data != nil) {
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        println(string)
    }
}

CFRunLoopRun() // dispatch
