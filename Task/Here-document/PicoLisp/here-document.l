(out "file.txt"                        # Write to "file.txt"
   (prinl "### This is before the text ###")
   (here "TEXT-END")
   (prinl "### This is after the text ###") )
"There must be some way out of here", said the joker to the thief
"There's too much confusion, I can't get no relief"
TEXT-END

(in "file.txt" (echo))                 # Show "file.txt"
