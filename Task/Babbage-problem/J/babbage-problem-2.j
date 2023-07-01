NB. In the interactive environment.
NB. First here, Mr Babbage, we'll make the computer's words more meaningful to an english speaker.

NB. The first is the "head" of a list, written with these inviting open arms that embrace one small dot :
   first=: {.

NB. The small i. notation denotes "all integers up to 100000". You've already found a solution in that range.
   n=: i. 100000

NB. This is how we write squaring.
   squareof=: *:

NB. In our notation, a dyad is a word that takes an x value on the left and an y value on the right.
   ends=: dyad : ' x = 1000000 | y '

NB. This dyad selects values from the list x, as marked by the list y
   where=: dyad : ' y # x '

NB. Now that we defined our words, we can ask our question with them :
   first n where 269696 ends squareof n
25264

NB. With a bit of habit, you won't need to define words in english anymore.
NB. The following easily relates word for word to the sentence we've written :
   {. (i.100000) #~ 269696 = 1000000 | *: i.100000
25264

NB. Like all mathematical notations, in J you see patterns that suggest simplification :
   {. I. 269696 = 1000000 | *: i.100000
25264
