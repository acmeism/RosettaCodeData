page_tree <- htmlTreeParse(web_page, useInternalNodes = TRUE)
times_node <- xpathSApply(page_tree, "//pre")[[1]]
times_node <- times_node[names(times_node) == "text"]
time_lines <- sapply(times_node, function(x) as(x, "character"))
