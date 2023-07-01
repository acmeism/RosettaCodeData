import Foundation

let request = NSURLRequest(URL: NSURL(string: "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")!)

NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {res, data, err in
    if (data != nil) {
        if let fileAsString = NSString(data: data, encoding: NSUTF8StringEncoding) {
            var firstCase = false
            var secondCase = false
            var cie = 0
            var cei = 0
            var not_c_ie = 0
            var not_c_ei = 0
            let words = fileAsString.componentsSeparatedByString("\n")
            for word in words {
                var wordRegex = RegexMutable(word as String)
                if (wordRegex["cie"]) {
                    cie++
                }
                if (wordRegex["cei"]) {
                    cei++
                }
                if (wordRegex["(^ie|[^c]ie)"].matches().count != 0) {
                    not_c_ie++
                }
                if (wordRegex["(^ei|[^c]ei)"].matches().count != 0) {
                    not_c_ei++
                }
            }


            if (not_c_ie > not_c_ei * 2) {
                println("I before E when not preceded by C is plausable")
                firstCase = true
            } else {
                println("I before E when not preceded by C is not plausable")
            }

            if (cei > cie * 2) {
                secondCase = true
                println("E before I when preceded by C is plausable")
            } else {
                println("E before I when preceded by C is not plausable")
            }

            if (firstCase && secondCase) {
                println("I before E except after C is plausible")
            } else {
                println("I before E except after C is not plausible")
            }
        }
    }
}

CFRunLoopRun()
