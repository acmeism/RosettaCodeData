(let* ((filename "input.txt")
       (stat (sb-posix:stat filename))
       (mtime (sb-posix:stat-mtime stat)))
  (sb-posix:utime filename
		  (sb-posix:stat-atime stat)
		  (sb-posix:time)))
