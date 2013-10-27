.say for                              # print each element of the array made this way:
slurp('unixdict.txt')\                # load file in memory
.words\                               # extract words
.classify( *.comb.sort.join )\        # group by common anagram
.classify( *.value.elems )\           # group by number of anagrams in a group
.max( :by(*.key) ).value\             # get the group with highest number of anagrams
».value                               # get all groups of anagrams in the group just selected
