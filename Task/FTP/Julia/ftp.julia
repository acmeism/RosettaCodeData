using FTPClient

ftp = FTP(hostname = "ftp.ed.ac.uk", username = "anonymous")
cd(ftp, "pub/courses")
println(readdir(ftp))
bytes = read(download(ftp, "make.notes.tar"))

close(ftp)
