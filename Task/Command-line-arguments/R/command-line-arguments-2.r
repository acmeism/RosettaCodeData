# Read the commandline arguments
args <- (commandArgs(TRUE))

# args is now a list of character vectors
# First check to see if any arguments were passed,
# then evaluate each argument.
if (length(args)==0) {
    print("No arguments supplied.")
    # Supply default values
    a <- 1
    b <- c(1,1,1)
} else {
    for (i in 1:length(args)) {
         eval(parse(text=args[[i]]))
    }
}
print(a*2)
print(b*3)
