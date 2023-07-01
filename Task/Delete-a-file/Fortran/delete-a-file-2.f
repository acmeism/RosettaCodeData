program DeleteFileExample
    use kernel32
    implicit none
    print *, DeleteFile("input.txt")
    print *, DeleteFile("\input.txt")
    print *, RemoveDirectory("docs")
    print *, RemoveDirectory("\docs")
end program
