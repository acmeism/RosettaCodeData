   ab:3 3#"abcdefghi"
("abc"
 "def"
 "ghi")

   dd:3 3#"012345678"
("012"
 "345"
 "678")

   ab,dd
("abc"
 "def"
 "ghi"
 "012"
 "345"
 "678")

   +ab,dd   / flip (transpose) join
("adg036"
 "beh147"
 "cfi258")

   ab,'dd   / eachpair join
("abc012"
 "def345"
 "ghi678")

   +(+ab),dd
("abc036"
 "def147"
 "ghi258")
