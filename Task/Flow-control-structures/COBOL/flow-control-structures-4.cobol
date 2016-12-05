       identification division.
       program-id. altering.

       procedure division.
       main section.

      *> And now for some altering.
       contrived.
       ALTER story TO PROCEED TO beginning
       GO TO story
       .

      *> Jump to a part of the story
       story.
       GO.
       .

      *> the first part
       beginning.
       ALTER story TO PROCEED to middle
       DISPLAY "This is the start of a changing story"
       GO TO story
       .

      *> the middle bit
       middle.
       ALTER story TO PROCEED to ending
       DISPLAY "The story progresses"
       GO TO story
       .

      *> the climatic finish
       ending.
       DISPLAY "The story ends, happily ever after"
       .

      *> fall through to the exit
       exit program.
