words = scan("https://web.archive.org/web/20180611003215/http://www.puzzlers.org/pub/wordlists/unixdict.txt",what = "character")

ordered = logical()
for(i in 1:length(words)){
  first = strsplit(words[i],"")[[1]][1:nchar(words[i])-1]
  second = strsplit(words[i],"")[[1]][2:nchar(words[i])]
  ordered[i] = all(first<=second)
}

cat(words[ordered][which(nchar(words[ordered])==max(nchar(words[ordered])))],sep="\n")
