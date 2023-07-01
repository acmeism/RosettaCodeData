func printAll(things ... string) {
  // it's as if you declared "things" as a []string, containing all the arguments
  for _, x := range things {
    fmt.Println(x)
  }
}
