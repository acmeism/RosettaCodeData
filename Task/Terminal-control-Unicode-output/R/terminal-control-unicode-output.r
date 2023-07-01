if (any(grepl("UTF", toupper(Sys.getenv(c("LANG", "LC_ALL", "LC_CTYPE")))))) {
        cat("Unicode is supported on this terminal and U+25B3 is : \u25b3\n")
} else {
        cat("Unicode is not supported on this terminal.")
}
