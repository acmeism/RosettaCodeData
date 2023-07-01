import "fmt"

func main() {
    for i := 0.; ; {
        fmt.Printf("%o\n", int64(i))
        /* uncomment to produce example output
        if i == 3 {
            i = float64(1<<53 - 4) // skip to near the end
            fmt.Println("...")
        } */
        next := i + 1
        if next == i {
            break
        }
        i = next
    }
}
