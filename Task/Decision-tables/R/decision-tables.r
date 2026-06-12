library(e1071)

conditions <- `colnames<-`(bincombinations(3), c("prints", "redlight", "recognised"))
actions <- c("power"="Check the power cable",
             "usb"="Check the printer-computer cable",
             "software"="Ensure printer software is installed",
             "ink"="Check/replace ink",
             "jam"="Check for paper jam")

prompts <- c("Does the printer print? Y/N: ",
             "Is a red light flashing? Y/N: ",
             "Is the printer recognised by the computer? Y/N: ")

troubleshooter <- data.frame("power"=c(1,0,0,0,0,0,0,0),
                             "usb"=c(1,0,1,0,0,0,0,0),
                             "software"=c(1,0,1,0,1,0,1,0),
                             "ink"=c(0,0,1,1,0,0,0,1),
                             "jam"=c(0,1,0,1,0,0,0,0))

troubleshooter <- cbind(conditions, troubleshooter)

troubleshoot_printer <- function(){
  read_input <- function(p) readline(prompt=p) |> tolower()
  input2bool <- function(s) switch(s, "y"=1, "n"=0, stop("Input must be Y or N"))
  answers <- sapply(prompts, read_input)
  bools <- sapply(answers, input2bool)
  actions_list <- subset(troubleshooter, prints==bools[1]&redlight==bools[2]&recognised==bools[3])[4:8]
  actions_raw <- Filter(`+`, actions_list) |> names()
  cat("Take the following actions:\n")
  if(length(actions_raw)==0) cat("No actions required!\n")
  writeLines(actions[actions_raw])
}

troubleshoot_printer()
