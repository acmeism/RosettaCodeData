for i in 1...10 {
    print(i, terminator: "")
    if i % 5 == 0 {
        print()
        continue
    }
    print(", ", terminator: "")
}
