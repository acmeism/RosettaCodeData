#!/usr/bin/pil

# Default seed
(seed (in "/dev/urandom" (rd 8)))

# Global defaults
(setq
   *PwCount 1
   *PwLength 12
   *UppChars (mapcar char (range (char "A") (char "Z")))
   *LowChars (mapcar lowc *UppChars)
   *Digits (mapcar format (range 0 9))
   *Others (chop "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~") )

# Command line options
(de -count ()
   (setq *PwCount (format (opt))) )

(de -length ()
   (setq *PwLength (format (opt))) )

(de -seed ()
   (seed (opt)) )

(de -exclude ()
   (for C (chop (opt))
      (del C '*UppChars)
      (del C '*LowChars)
      (del C '*Digits)
      (del C '*Others) ) )

(de -help ()
   (prinl "Generate password(s)")
   (prinl "Options:")
   (prinl "   --help")
   (prinl "   --count <num>")
   (prinl "   --length <num>")
   (prinl "   --seed <chars>")
   (prinl "   --exclude <chars>")
   (bye) )

(load T)

# Return random character from list
(de randChar (Lst)
   (get Lst (rand 1 (length Lst))) )

# Generate password(s)
(do *PwCount
   (prinl
      (by '(NIL (rand)) sort
         (make
            (link
               (randChar *UppChars)  # At least one from each group
               (randChar *LowChars)
               (randChar *Digits)
               (randChar *Others) )
            (do (- *PwLength 4)
               (link
                  (randChar
                     (caar
                        (rot '(*UppChars *Others *Digits *LowChars))) ) ) ) ) ) ) )

(bye)
