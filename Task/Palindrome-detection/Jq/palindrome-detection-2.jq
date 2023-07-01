def isPalindrome:
  length as $n
  | explode as $in
  | first(range(0; $n/2)
          | select($in[.] != $in[$n - 1 - .]) )
    // false
  | not;
