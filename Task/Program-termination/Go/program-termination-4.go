func pcj() {
    fmt.Println("at the junction")
    defer func() {
        fmt.Println("deferred from pcj")
    }()
    panic(10)
}

func main() {
    fmt.Println("main program start")
    defer func() {
        fmt.Println("deferred from main")
    }()
    go pcj()
    time.Sleep(1e9)
    fmt.Println("main program done")
}
