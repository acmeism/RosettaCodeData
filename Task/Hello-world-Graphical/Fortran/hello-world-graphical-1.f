program hello
    use windows
    integer :: res
    res = MessageBox(0, LOC("Hello, World"), LOC("Window Title"), MB_OK)
end program
