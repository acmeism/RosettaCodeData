cat("\033[?1049h\033[H")
cat("Alternate screen buffer\n")
for (i in 5:1) {
        cat("\rgoing back in ", i, "...", sep = "")
        Sys.sleep(1)
        cat("\33[2J")
}
cat("\033[?1049l")
