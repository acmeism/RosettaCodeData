def walkDirectory(directory, pattern) {
  for name => file ? (name =~ rx`.*$pattern.*`) in directory {
    println(name)
  }
}
