#Aamrun, 5th November 2021

import urllib.request
from collections import Counter

urllib.request.urlretrieve("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt", "unixdict.txt")

dictionary = open("unixdict.txt","r")

wordList = dictionary.read().split('\n')

dictionary.close()

filteredWords = [chosenWord for chosenWord in wordList if len(chosenWord)>=9]

for word in filteredWords[:-9]:
  position = filteredWords.index(word)
  newWord = "".join([filteredWords[position+i][i] for i in range(0,9)])
  if newWord in filteredWords:
   print(newWord)
