wordcount<-function(file,n){
  punctuation=c("`","~","!","@","#","$","%","^","&","*","(",")","_","+","=","{","[","}","]","|","\\",":",";","\"","<",",",">",".","?","/","'s")
  wordlist=scan(file,what=character())
  wordlist=tolower(wordlist)
  for(i in 1:length(punctuation)){
    wordlist=gsub(punctuation[i],"",wordlist,fixed=T)
  }
  df=data.frame("Word"=sort(unique(wordlist)),"Count"=rep(0,length(unique(wordlist))))
  for(i in 1:length(unique(wordlist))){
    df[i,2]=length(which(wordlist==df[i,1]))
  }
  df=df[order(df[,2],decreasing = T),]
  row.names(df)=1:nrow(df)
  return(df[1:n,])
}
