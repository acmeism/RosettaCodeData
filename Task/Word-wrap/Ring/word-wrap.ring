# Project : Word wrap

load "stdlib.ring"

doc = "In olden times when wishing still helped one, there lived a king
whose daughters were all beautiful, but the youngest was so beautiful
that the sun itself, which has seen so much, was astonished whenever
it shone in her face.  Close by the king's castle lay a great dark
forest, and under an old lime-tree in the forest was a well, and when
the day was very warm, the king's child went out into the forest and
sat down by the side of the cool fountain, and when she was bored she
took a golden ball, and threw it up on high and caught it, and this
ball was her favorite plaything."

wordwrap(doc,72)
wordwrap(doc,80)

func wordwrap(doc, maxline)
        words = split(doc, " ")
        line = words[1]
        for i=2 to len(words)
             word = words[i]
            if len(line)+len(word)+1 > maxline
               see line + nl
               line = word
            else
               line = line + " " + word
           ok
        next
        see line + nl + nl
