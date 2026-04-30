/* Does cheesecake start with cheese? */
"cheesecake" "cheese" head?   ! t
/* Does cheesecake contain sec at any location? */
"sec" "cheesecake" subseq?   ! t
/* Does cheesecake end with cake? */
"cheesecake" "cake" tail?   ! t
/* Where in cheesecake is the leftmost sec? */
"sec" "cheesecake" subseq-start   ! 4
/* Where in Mississippi are all occurrences of iss? */
USE: regexp
"Mississippi" "iss" <regexp> all-matching-slices [ from>> ] map   ! { 1 4 }
