#Declare some integers
qqq <- 45L
www <- -3L
#Retrieve the name of all the variables in the user workspace
var_names <- ls()
#Retrieve the actual variables as a list
all_vars <- mget(var_names, globalenv())
#See which ones are integers
is_int <- sapply(all_vars, is.integer)
#Count them
sum(is_int)
#Retrieve the variables that were integers
the_ints <- mget(varnames[is_int], globalenv())
#Add them up
sum(unlist(the_ints))
