func main() {
    for i := uint16(0); ; i++ {  // type specified here
        fmt.Printf("%o\n", i)
        if i == math.MaxUint16 { // maximum value for type specified here
            break
        }
    }
}
