BEGIN {
  printf "" > "output.txt"
  # try to create the file in the root (for *nix-like systems)
  printf "" > "/output.txt"
}
