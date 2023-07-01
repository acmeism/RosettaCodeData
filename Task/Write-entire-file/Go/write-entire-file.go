import "io/ioutil"

func main() {
    ioutil.WriteFile("path/to/your.file", []byte("data"), 0644)
}
