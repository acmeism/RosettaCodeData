#!/bin/gawk -f
BEGIN{
FS=""
wordcount = 0
maxlength = 0

}
# hash generates the sorted sequence of characters in a word,
# so that the hashes for a pair of anagrams will be the same.
# Example: hash meat = aemt and hash team = aemt
function hash(myword, i,letters,myhash){
  split(myword,letters,"")
  asort(letters)
  for (i=1;i<=length(myword);i++) myhash=myhash letters[i]
  return myhash
}
# deranged checks two anagrems for derangement
function deranged(worda, wordb,  a,b,i,n,len){
  n=0
  len=split(worda,a,"")
  split(wordb,b,"")
  for (i=len; i>=1; i--){
      if (a[i] == b[i]) n = n+1
  }
  return n==0
}

# field separator null makes gawk split input record character by character.
# the split function works the same way
{
  wordcount = wordcount + 1
  fullword[wordcount]=$0
  bylength[length($0)]=bylength[length($0)]  wordcount "|"
  if (length($0) > maxlength) maxlength = length($0)
}

END{
 for (len=maxlength; len>1; len--){
  numwords=split(bylength[len],words,"|")
  split("",hashed)
 split("",anagrams)
  for (i=1;i<=numwords;i++){
#   make lists of anagrams in hashed
      myword = fullword[words[i]]
      myhash = hash(myword)
      hashed[myhash] = hashed[myhash] myword " "
  }
# check anagrams for derangement
 for (myhash in hashed){
     n = split(hashed[myhash],anagrams," ")
     for (i=1; i< n; i++)
         for (j=i+1; j<=n; j++){
             if(deranged(anagrams[i],anagrams[j])) found = found anagrams[i] " " anagrams[j] " "
          }
  }
 if (length(found) > 0 ) print "deranged: " found
  if (length(found) > 0) exit
 }
}
