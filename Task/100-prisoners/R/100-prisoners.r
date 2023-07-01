t = 100000 #number of trials
success.r = rep(0,t) #this will keep track of how many prisoners find their ticket on each trial for the random method
success.o = rep(0,t) #this will keep track of how many prisoners find their ticket on each trial for the optimal method

#random method
for(i in 1:t){
  escape = rep(F,100)
  ticket = sample(1:100)
  for(j in 1:length(prisoner)){
    escape[j] = j %in% sample(ticket,50)
  }
  success.r[i] = sum(escape)
}

#optimal method
for(i in 1:t){
  escape = rep(F,100)
  ticket = sample(1:100)
  for(j in 1:100){
    boxes = 0
    current.box = j
    while(boxes<50 && !escape[j]){
      boxes=boxes+1
      escape[j] = ticket[current.box]==j
      current.box = ticket[current.box]
    }
  }
  success.o[i] = sum(escape)
}

cat("Random method resulted in a success rate of ",100*mean(success.r==100),
    "%.\nOptimal method resulted in a success rate of ",100*mean(success.o==100),"%.",sep="")
