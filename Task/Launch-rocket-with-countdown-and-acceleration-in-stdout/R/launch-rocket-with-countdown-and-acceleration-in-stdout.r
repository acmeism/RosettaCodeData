rocket <- c("   /\\   ",
            "  /  \\  ",
            "  |  |  ",
            "  |  |  ",
            " /|/\\|\\ ",
            "/_||||_\\")

launch_rocket <- function(){
  cat("Launch in T minus: ")
  for(i in 5:1){
    cat(i, "")
    Sys.sleep(1)
  }
  cat("\nLift off!\n")
  writeLines(rocket)
  for(i in 1:5){
    cat(rep("  ****  \n", i), sep="")
    Sys.sleep(0.25)
  }
}

launch_rocket()
