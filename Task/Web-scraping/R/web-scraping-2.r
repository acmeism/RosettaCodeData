library(stringr)
utc_line <- all_lines[str_detect(all_lines, "UTC")]
utc_time_str <- str_extract(utc_line, "\\w{3}.*UTC")
