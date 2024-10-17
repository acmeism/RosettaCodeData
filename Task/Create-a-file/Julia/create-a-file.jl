# many I/O functions have UNIX names

touch("output.txt")
mkdir("docs")

# probably don't have permission
try
    touch("/output.txt")
    mkdir("/docs")
catch e
    warn(e)
end
