fname <- "notes.txt"
len <- file.info(fname)$size
conn <- file(fname, 'r')
contents <- readChar(conn, len)
close(conn)
