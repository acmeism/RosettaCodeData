import "os"

func processFile() {
    f, err := os.Open("file")
    if err != nil {
        // (probably do something with the error)
        return // no need to close file, it didn't open
    }
    defer f.Close() // file is open.  no matter what, close it on return
    var lucky bool
    // some processing
    if (lucky) {
        // f.Close() will get called here
        return
    }
    // more processing
    // f.Close() will get called here too
}
