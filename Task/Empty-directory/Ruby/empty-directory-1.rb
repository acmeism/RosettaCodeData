# Checks if a directory is empty, but raises SystemCallError
# if _path_ is not a directory.
def empty_dir?(path)
  not Dir.foreach(path).detect {|f| f != '.' and f != '..'}
end
