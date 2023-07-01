import Foundation

// With https
let request = NSURLRequest(URL: NSURL(string: "https://sourceforge.net")!)

NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {res, data, err in // callback

    // data is binary
    if (data != nil) {
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        println(string)
    }
}

CFRunLoopRun() // dispatch
