(defun c:TDOC ( / days gifts)
  (setq days
   '(
      ("first"    "A partridge in a pear tree.")
      ("second"   "Two turtle doves and")
      ("third"    "Three french hens")
      ("fourth"   "Four calling birds")
      ("fifth"    "Five golden rings")
      ("sixth"    "Six geese a-laying")
      ("seventh"  "Seven swans a-swimming")
      ("eighth"   "Eight maids a-milking")
      ("ninth"    "Nine ladies dancing")
      ("tenth"    "Ten lords a-leaping")
      ("eleventh" "Eleven pipers piping")
      ("twelfth"  "Twelve drummers drumming")
    )
  )
  (setq gifts "")
  (foreach day days
    (prompt
      (strcat
        "\n-----"
        "\nOn the " (car day) " day of Christmas,"
        "\nMy true love gave to me:"
        (setq gifts (strcat "\n" (cadr day) gifts))
      )
    )
  )
  (princ)
)
