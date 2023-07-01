def walkTree(directory, pattern) {
  for name => file in directory {
    if (name =~ rx`.*$pattern.*`) {
      println(file.getPath())
    }
    if (file.isDirectory()) {
      walkTree(file, pattern)
    }
  }
}
