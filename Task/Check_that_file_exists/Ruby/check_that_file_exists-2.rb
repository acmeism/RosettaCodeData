["input.txt", "/input.txt"].each { |f|
  printf "%s is a regular file? %s\n", f, File.file?(f) }
["docs", "/docs"].each { |d|
  printf "%s is a directory? %s\n", d, File.directory?(d) }
