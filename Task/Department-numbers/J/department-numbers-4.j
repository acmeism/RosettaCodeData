     NB. 3 departments, 1..7 in each
     #rule1=. >,{3#<1+i.7
343
     NB. total must be 12, numbers must be unique
     #rule2=. (#~ ((3=#@~.) * 12=+/)"1) rule1
30
     NB. no odd numbers in police department (first department)
     #rule3=. (#~ 0=2|{."1) rule2
14
     rule3
2 3 7
2 4 6
2 6 4
2 7 3
4 1 7
4 2 6
4 3 5
4 5 3
4 6 2
4 7 1
6 1 5
6 2 4
6 4 2
6 5 1
