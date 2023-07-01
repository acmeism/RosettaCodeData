import Foundation

let myList = ["Enjoy", "Rosetta", "Code"]

for word in myList {
    dispatch_async(dispatch_get_global_queue(0, 0)) {
        NSLog(word)
    }
}

dispatch_main()
