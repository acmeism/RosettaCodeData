procedure main()
m := open(url := "http://tycho.usno.navy.mil/cgi-bin/timer.pl","m") | stop("Unable to open ",url)
every (p := "") ||:= |read(m)                                                    # read the page into a single string
close(m)

map(p) ? ( tab(find("<br>")), ="<br>", write("UTC time=",p[&pos:find(" utc")]))  # scrape and show
end
