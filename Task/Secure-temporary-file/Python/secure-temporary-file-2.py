fd, path = tempfile.mkstemp()
try:
    # use the path or the file descriptor
finally:
    os.close(fd)
