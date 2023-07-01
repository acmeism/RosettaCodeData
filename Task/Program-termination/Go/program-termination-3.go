func main() {
    fmt.Println("main program start")

    // this will not get run on os.Exit
    defer func() {
        fmt.Println("deferred function")
    }()

    if problem {
        fmt.Println("main program exiting")
        os.Exit(-1)
    }
}
