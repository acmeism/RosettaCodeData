# Checks if a directory is empty, but raises SystemCallError
# if _path_ is not a directory.
def empty_dir?(path)
  Dir.foreach(path) {|f|
    return false if f != '.' and f != '..'
  }
  return true
end
