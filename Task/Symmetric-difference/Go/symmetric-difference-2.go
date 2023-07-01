func main() {
    for e := range b {
        delete(a, e)
    }
    fmt.Println(a)
}
