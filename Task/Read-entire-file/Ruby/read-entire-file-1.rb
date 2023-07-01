# Read entire text file.
str = IO.read "foobar.txt"

# It can also read a subprocess.
str = IO.read "| grep ftp /etc/services"
