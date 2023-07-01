# Truncate a file named "myfile" to 1440 kilobytes.
ls myfile >/dev/null &&
  dd if=/dev/null of=myfile bs=1 seek=1440k
