largest_LynchBell_number <- function(from, to){
  from = round(from)
  to = round(to)
  to_chosen = to

  if(to > 9876432) to = 9876432  #cap the search space to this number

  LynchBell = NULL

  range <- to:from #search starting from the end of the range
  range <- range[range %% 5 != 0] #reduce search space

  for(n in range){
    splitted <- strsplit(toString(n), "")[[1]]
    if("0" %in% splitted | "5" %in% splitted) next
    if (length(splitted) != length(unique(splitted))) next

    for (i in splitted) {
      if(n %% as.numeric(i) != 0) break
      if(which(splitted == i) == length(splitted)) LynchBell = n
    }
    if(!is.null(LynchBell)) break
  }

  message(paste0("The largest Lynch-Bell numer between ", from, " and ", to_chosen, " is ", LynchBell))
  return(LynchBell)
}

#Verify (in less than 2 seconds)
for(i in 10^(1:8)){
  largest_LynchBell_number(1, i)
}
