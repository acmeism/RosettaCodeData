# Requires Unicon version 13
procedure main(arglist)
    url := (\arglist[1] | "https://sourceforge.net/")
    w := open(url, "m-") | stop("Cannot open " || url)
    while write(read(w))
    close(w)
end
