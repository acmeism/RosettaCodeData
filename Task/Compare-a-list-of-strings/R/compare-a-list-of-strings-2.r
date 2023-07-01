manyStrings=list(
  "a",
  c("a", "b", "c"),
  c("a", "c", "b"),
  c("A", "A"),
  c("a", "A"),
  c(123, "A", "Aaron", "beryllium", "z"),
  c(123, "A", "z", "Aaron", "beryllium", "z")
)

for (strings in manyStrings) {
  print(strings)
  print(all(strings == strings[1]))
  print(all(strings == sort(strings)))
}
