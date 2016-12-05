.put for                         # print each element of the array made this way:
    'unixdict.txt'.IO.words      # load words from file
    .classify(*.comb.sort.join)  # group by common anagram
    .classify(*.value.elems)     # group by number of anagrams in a group
    .max(*.key).value            # get the group with highest number of anagrams
    .map(*.value)                # get all groups of anagrams in the group just selected
