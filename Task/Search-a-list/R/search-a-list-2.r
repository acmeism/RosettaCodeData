haystack1 <- c("where", "is", "the", "needle", "I", "wonder")
haystack2 <- c("no", "sewing", "equipment", "in", "here")
haystack3 <- c("oodles", "of", "needles", "needles", "needles", "in", "here")

find.needle(haystack1)                              # 4
find.needle(haystack2)                              # error
find.needle(haystack3)                              # 3
find.needle(haystack3, needle="needles", ret=TRUE)  # 3 5
