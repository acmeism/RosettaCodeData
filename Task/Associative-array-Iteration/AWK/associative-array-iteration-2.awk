BEGIN {
  a["hello"] = 1
  a["world"] = 2
  a["!"] = 3
  PROCINFO["sorted_in"] = "@ind_str_asc" # controls index order
  # iterate over keys, indices as strings sorted ascending
  for(key in a) {
    print key, a[key]
  }
}
