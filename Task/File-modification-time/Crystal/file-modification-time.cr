# get
mtime = File.info(filename).modification_time

# set
File.touch(filename)  # default: now; or
File.touch(filename, time)
