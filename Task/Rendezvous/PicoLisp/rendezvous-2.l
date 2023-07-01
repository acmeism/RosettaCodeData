(de printLine (Str)
   (cond
      ((gt0 *Ink) (prinl *ID ": " Str) (dec '*Ink))
      (*Backup (rendezvousPrint @ Str) T)
      (T (quit "Out of Ink")) ) )

(de rendezvousPrint (Printer Str)
   (let Rendezvous NIL
      (tell Printer 'rendezvous *Pid 'printLine Str)  # Call entry point
      (unless (wait 6000 Rendezvous)                  # Block max. 1 minute
         (quit "Rendezvous timed out") ) ) )

# Start RESERVE printer process
(unless (setq *ReservePrinter (fork))
   (setq *ID 2  *Ink 5)
   (wait) )  # Run forever

# Start MAIN printer process
(unless (setq *MainPrinter (fork))
   (setq *ID 1  *Ink 5  *Backup *ReservePrinter)
   (wait) )

# Start Humpty Dumpty process
(unless (fork)
   (when
      (catch '(NIL)
         (for Line
            (quote
               "Humpty Dumpty sat on a wall."
               "Humpty Dumpty had a great fall."
               "All the king's horses and all the king's men"
               "Couldn't put Humpty together again." )
            (rendezvousPrint *MainPrinter Line) ) )
      (prinl "      Humpty Dumpty: " @ "!") )
   (bye) )

# Start Mother Goose process
(unless (fork)
   (when
      (catch '(NIL)
         (for Line
            (quote
               "Old Mother Goose"
               "When she wanted to wander,"
               "Would ride through the air"
               "On a very fine gander."
               "Jack's mother came in,"
               "And caught the goose soon,"
               "And mounting its back,"
               "Flew up to the moon." )
            (rendezvousPrint *MainPrinter Line) ) )
      (prinl "      Mother Goose: " @ "!") )
   (bye) )

# Prepare to terminate all processes upon exit
(push '*Bye '(tell 'bye))
