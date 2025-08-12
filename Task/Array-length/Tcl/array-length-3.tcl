set paths  [split "/sbin:/bin:/usr/bin:/usr/local/bin:$home/bin" ":"]

foreach p $paths {
  puts "$p"
}
