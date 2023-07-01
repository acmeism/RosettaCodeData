modestring <- 'row,col'
mode.vec <- unlist(strsplit(modestring, ','))
mode.vec[1] # "row"
mode.vec[2] # "col"
if (mode.vec[2] == 'col') { cat('Col!\n') } # Col! (with no quotes)
if (mode.vec[1] == "row") { cat('Row!\n') } # Row!
