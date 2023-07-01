p <- parallel::mcparallel({
        Sys.sleep(1)
        cat("\tChild pid: ", Sys.getpid(), "\n")
        TRUE
})
cat("Main pid: ", Sys.getpid(), "\n")
parallel::mccollect(p)

p <- parallel:::mcfork()
if (inherits(p, "masterProcess")) {
        Sys.sleep(1)
        cat("\tChild pid: ", Sys.getpid(), "\n")
        parallel:::mcexit(, TRUE)
}
cat("Main pid: ", Sys.getpid(), "\n")
unserialize(parallel:::readChildren(2))
