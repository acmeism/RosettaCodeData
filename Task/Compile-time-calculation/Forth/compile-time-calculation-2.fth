: more  ( "digits" -- )  \ store "1234" as 1 c, 2 c, 3 c, 4 c,
  parse-word bounds ?do
    i c@ [char] 0 - c,
  loop ;

create bignum
more 73167176531330624919225119674426574742355349194934
more 96983520312774506326239578318016984801869478851843
...
