# The old Bourne Shell interprets 'IFS= read' as 'IFS= ; read'.
# It requires extra code to restore the original value of IFS.
exec 3<input.txt
oldifs=$IFS
while IFS= ; read -r line <&3 ; do
  IFS=$oldifs
  printf '%s\n' "$line"
done
IFS=$oldifs
exec 3>&-
