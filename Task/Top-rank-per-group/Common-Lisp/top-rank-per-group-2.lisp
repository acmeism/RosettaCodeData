> (defparameter *employee-data*
  '(("Tyler Bennett" E10297 32000 D101)
    ("John Rappl" E21437 47000 D050)
    ("George Woltman" E00127 53500 D101)
    ("Adam Smith" E63535 18000 D202)
    ("Claire Buckman" E39876 27800 D202)
    ("David McClellan" E04242 41500 D101)
    ("Rich Holcomb" E01234 49500 D202)
    ("Nathan Adams" E41298 21900 D050)
    ("Richard Potter" E43128 15900 D101)
    ("David Motsinger" E27002 19250 D202)
    ("Tim Sampair" E03033 27000 D101)
    ("Kim Arlich" E10001 57000 D190)
    ("Timothy Grove" E16398 29900 D190))
  "A list of lists of each employee's name, id, salary, and
department.")
*EMPLOYEE-DATA*

> (top-n-by-group 3 *employee-data* 'third 'fourth '>)
#<EQL Hash Table{4} 2361A0E7>

> (describe *)

#<EQL Hash Table{4} 2361A0E7> is a HASH-TABLE
D101      (3 (("Tyler Bennett" E10297 32000 D101) ("David McClellan" E04242 41500 D101) ("George Woltman" E00127 53500 D101)))
D050      (2 (("Nathan Adams" E41298 21900 D050) ("John Rappl" E21437 47000 D050)))
D202      (3 (("David Motsinger" E27002 19250 D202) ("Claire Buckman" E39876 27800 D202) ("Rich Holcomb" E01234 49500 D202)))
D190      (2 (("Timothy Grove" E16398 29900 D190) ("Kim Arlich" E10001 57000 D190)))
