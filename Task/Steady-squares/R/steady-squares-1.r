for (i in 1:10000) {
  if (endsWith(as.character(i^2), as.character(i))) {
    cat(i, "^2 = ", i^2, "\n", sep = "")
  }
}
