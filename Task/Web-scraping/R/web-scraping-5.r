library(XML)
page_tree <- htmlTreeParse(webpage)
times_node <- page_tree$children$html$children$body$children$h3$children$pre$children
times_node <- times_node[names(times_node) == "text"]
time_lines <- sapply(times_node, function(x) x$value)
