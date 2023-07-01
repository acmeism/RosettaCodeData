program hello
    use user32
    integer :: res
    res = MessageBox(0, "Hello, World", "Window Title", MB_OK)
end program
