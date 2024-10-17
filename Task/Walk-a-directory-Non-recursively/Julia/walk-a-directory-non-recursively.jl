for filename in readdir("/foo/bar")
    if endswith(filename, ".mp3")
        print(filename)
    end
end
