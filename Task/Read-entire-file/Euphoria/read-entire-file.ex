function load_file(sequence filename)
  integer fn,c
  sequence data
    fn = open(filename,"r") -- "r" for text files, "rb" for binary files
    if (fn = -1) then return {} end if -- failed to open the file

    data = {} -- init to empty sequence
    c = getc(fn) -- prime the char buffer
    while (c != -1) do -- while not EOF
      data &= c -- append each character
      c = getc(fn) -- next char
    end while

    close(fn)
    return data
end function
