package main
import "fmt"

func makeList(separator string) string {
    counter := 1

    makeItem := func(item string) string {
        result := fmt.Sprintf("%d%s%s\n", counter, separator, item)
        counter += 1
        return result
    }

    return makeItem("first") + makeItem("second") + makeItem("third")
}

func main() {
    fmt.Print(makeList(". "))
}
