# This loop runs in the current shell, and can read both
# the old standard input (fd 1) and input.txt (fd 3).
exec 3<input.txt
while IFS= read -r line <&3 ; do
  printf '%s\n' "$line"
done
exec 3>&-
