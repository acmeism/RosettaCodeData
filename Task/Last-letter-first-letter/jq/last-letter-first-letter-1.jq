# convert a list of unique words to a dictionary
def dictionary:
  reduce .[] as $word ({}; .[$word[0:1]] += [$word]) ;

# remove "word" from the input dictionary assuming the key is already there:
def remove(word):
 .[word[0:1]] -= [word];
