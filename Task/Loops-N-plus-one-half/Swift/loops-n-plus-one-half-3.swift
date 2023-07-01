for var i = 1; ; i++ {
    print(i, terminator: "")
    if i == 10 {
        print("")
        break
    }
    print(", ", terminator: "")
}
