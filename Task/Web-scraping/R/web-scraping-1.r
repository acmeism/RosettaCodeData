all_lines <- readLines("http://tycho.usno.navy.mil/cgi-bin/timer.pl")
utc_line <- grep("UTC", all_lines, value = TRUE)
matched <- regexpr("(\\w{3}.*UTC)", utc_line)
utc_time_str <- substring(line, matched, matched + attr(matched, "match.length") - 1L)
