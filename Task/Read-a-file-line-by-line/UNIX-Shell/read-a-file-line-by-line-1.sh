# This while loop repeats for each line of the file.
# This loop is inside a pipeline; many shells will
# run this loop inside a subshell.
cat input.txt |
while IFS= read -r line ; do
  printf '%s\n' "$line"
done
